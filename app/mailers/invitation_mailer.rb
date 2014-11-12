class InvitationMailer < ActionMailer::Base
  default from: 'info@katuma.org'

  def invite_user(invitation)
    @user = invitation.user
    @id = invitation.id
    @group = invitation.group
    @url = url_for(controller: 'api/v1/invitations', action: 'accept', only_path: false, id: @id, email: invitation.email)

    mail(to: invitation.email, subject: "#{ @user.name } invited you to join Katuma")
  end
end
