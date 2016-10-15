module Onboarding
  class InvitationService

    # Persists the Invitation and enqueues an InvitationJob
    #
    # @param group [Group]
    # @param inviting_user [User]
    # @param email [String]
    # @return [Invitation]
    def create!(group, inviting_user, email)
      invitation = load_invitation(group, inviting_user, email)

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
      emails.each { |email| create!(group, inviting_user, email) }
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

    # Marks invitation as accepted
    #
    # @param invitation [Onboarding::Invitation]
    def mark_invitation_as_accepted(invitation)
      invitation.accepted = true
      invitation.save
    end

    # Adds invited user to group with role :member
    #
    # @param group_id [Integer]
    # @param user_id [Integer]
    def add_member_to_group(group_id, user_id)
      membership = ::Onboarding::Membership.find_by(user_id: user_id, group_id: group_id)
      return if membership

      # TODO: use #find_by_id and raise custom exception
      group = ::BasicResources::Group.find(group_id)
      group.memberships.create(
        user_id: user_id,
        role: ::BasicResources::Membership::ROLES[:member]
      )
    end

    # Find or create the invitation
    #
    # @param group [Onboarding::Group]
    # @param inviting_user [Onboarding::User]
    # @param email [String]
    # @return [Onboarding::Invitation]
    def load_invitation(group, inviting_user, email)
      invitation = Invitation.where(group: group, email: email).first
      invitation ||= Invitation.new(group: group, email: email, invited_by: inviting_user)
      invitation
    end
  end
end
