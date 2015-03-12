class InvitationMailer < ActionMailer::Base
  helper :public_url
  default from: 'info@katuma.org'

  def invite_user(invitation)
    @invitation = invitation
    @user = invitation.user
    @id = invitation.id
    @group = invitation.group

    mail(to: invitation.email, subject: "#{ @user.name } invited you to join Katuma")
  end
end
