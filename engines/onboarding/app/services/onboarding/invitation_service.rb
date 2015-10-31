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
    # a new user is created and added to the group which has been invited
    #
    # @param signup [Account::Signup]
    # @param options [Hash]
    # @option options [String] :username
    # @option options [String] :password
    # @option options [String] :password_confirmation
    # @option options [String] :first_name
    # @option options [String] :last_name
    # @return [Account::User]
    def accept!(invitation, options)
      user = ::Account::User.new(
        email: signup.email,
        username: options[:username],
        password: options[:password],
        password_confirmation: options[:password_confirmation],
        first_name: options[:first_name],
        last_name: options[:last_name]
      )

      ::ActiveRecord::Base.transaction do
        invitation.destroy if user.save
      end

      user
    end

    private

    def load_invitation(email, group, inviting_user)
      invitation = Invitation.where(group: group, email: email).first
      invitation ||= Invitation.new(group: group, email: email, invited_by: inviting_user)
      invitation
    end
  end
end
