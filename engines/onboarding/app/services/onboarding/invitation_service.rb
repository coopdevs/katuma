module Onboarding
  class InvitationService

    def initialize
    end

    # Persists the Invitation and enqueues an InvitationJob
    #
    # @param email [String]
    # @param group [Group]
    # @param inviting_user [User]
    # @return [Invitation]
    def create!(email, group, inviting_user)
      invitation = load_invitation(email, group, inviting_user)

      if invitation.save
        # TODO: move to background job
        # invitation.update_attribute(sent_at: Time.zone.utc.now)
        InvitationMailer.invite_user(invitation).deliver
      end

      invitation
    end

    # Enqueues a job to create a bunch of invitations
    #
    # @param group [Group]
    # @param inviting_user [User]
    # @param emails [Array<String>]
    def bulk_invite!(group, inviting_user, emails)
      # TODO: move to background job
      emails.each { |email| create!(email, group, inviting_user) }
    end

    # Accepts an invitation
    # If user already in db join they to that group if not present.
    # If user not in db create and add to group.
    # In both cases mark invitation as accepted
    #
    # @param invitation [Account::Invitation]
    # @param options [Hash]
    # @option options [String] :username
    # @option options [String] :password
    # @option options [String] :password_confirmation
    # @option options [String] :first_name
    # @option options [String] :last_name
    # @return [Account::User]
    def accept!(invitation, options)
      user = ::Account::User.find_by(email: invitation.email)

      if user
        mark_invitation_as_accepted(invitation)
        add_member_to_group(invitation.group.id, user.id)
      else
        user = ::Account::User.new(
          email: invitation.email,
          username: options[:username],
          password: options[:password],
          password_confirmation: options[:password_confirmation],
          first_name: options[:first_name],
          last_name: options[:last_name]
        )

        ::ActiveRecord::Base.transaction do
          if user.save
            mark_invitation_as_accepted(invitation)
            add_member_to_group(invitation.group.id, user.id)
          end
        end
      end

      user
    end

    private

    # Mark invitation as accepted
    #
    # @param invitation [Onboarding::Invitation]
    def mark_invitation_as_accepted(invitation)
      invitation.accepted = true
      invitation.save
    end

    # Add user to group as meber
    #
    # @param group_id [Inteeger]
    # @param user_id [Integer]
    def add_member_to_group(group_id, user_id)
      member = ::Group::Membership.find_by(user_id: user_id, group_id: group_id)
      return if member

      group = ::Group::Group.find group_id
      group.memberships.create(
        user_id: user_id,
        role: ::Group::Membership::ROLES[:member]
      )
    end

    def load_invitation(email, group, inviting_user)
      invitation = Invitation.where(group: group, email: email).first
      invitation ||= Invitation.new(group: group, email: email, invited_by: inviting_user)
      invitation
    end
  end
end
