module Onboarding
  class InvitationMailer < ActionMailer::Base
    default from: 'info@katuma.org'

    # @param invitation [Invitation]
    def invite_user(invitation)
      @invitation = invitation
      @user = invitation.invited_by
      @group = invitation.group
      @url = accept_url

      mail(to: invitation.email, subject: "#{ @user.first_name } invited you to join Katuma")
    end

    private

    # TODO Find a way to manage express URLs
    #
    # @return [String]
    def accept_url
      "http://localhost:8000/invitation/accept/#{@invitation.token}"
    end
  end
end
