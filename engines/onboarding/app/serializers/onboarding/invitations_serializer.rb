module Onboarding
  class InvitationsSerializer < Shared::BaseSerializer

    schema do
      type 'invitations'

      collection :invitations, item, InvitationSerializer
    end
  end
end
