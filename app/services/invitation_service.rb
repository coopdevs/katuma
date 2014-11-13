class InvitationService
  attr_accessor :invitation, :creator

  # @param invitation [Invitation]
  def initialize(invitation)
    @invitation = invitation
  end

  # Persists the Invitation
  # and enqueues an InvitationJob
  #
  # @return [Boolean]
  def create
    if @invitation.save
      send_invitation_email

      true
    end
  end

  # Accepts an invitation
  # a new user is created and added to the group which has been invited
  def accept!
    create_user
    add_user_to_group

    @invitation.destroy
  end

  private

  # Sends the invitation by email
  def send_invitation_email
    InvitationMailer.invite_user(@invitation).deliver
  end

  def create_user
  end

  def add_user_to_group
  end
end
