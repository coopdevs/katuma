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

    # @return [String]
    def accept_url
      "#{::Shared::FrontendUrl.base_url}/invitation/accept/#{@invitation.token}"
    end
  end
end
