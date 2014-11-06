class InvitationCreator
  attr_accessor :invitation, :creator

  # @param invitation [Invitation]
  # @param creator [User]
  def initialize(invitation, creator)
    @invitation = invitation
    @creator = creator
  end

  # Creates a new Invitation
  # and enqueue the InvitationJob
  def create
    Invitation.transaction do
      @invitation.user = creator
      if @invitation.save
        enqueue_invitation_job
      end
    end
  end

  private

  def enqueue_invitation_job
  end
end
