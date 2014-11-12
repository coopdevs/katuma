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
    Invitation.transaction do
      if @invitation.save
        enqueue_invitation_job

        true
      end
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

  # Enqueues an InvitationJob to send the invitation
  def enqueue_invitation_job
  end

  def create_user
  end

  def add_user_to_group
  end
end
