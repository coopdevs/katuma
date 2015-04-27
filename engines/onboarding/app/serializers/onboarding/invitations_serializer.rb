module Onboarding
  class InvitationsSerializer < BaseSerializer

    schema do
      type 'invitations'

      collection :invitations, item, InvitationSerializer
    end
  end
end
