module Onboarding
  class InvitationSerializer < Shared::BaseSerializer

    schema do
      type 'invitation'

      map_properties :id, :email, :group_id, :invited_by_id, :sent_at, :created_at, :updated_at
    end
  end
end
