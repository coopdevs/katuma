class InvitationSerializer < BaseSerializer

  schema do
    type 'invitation'

    map_properties :id, :email, :group_id, :invited_by, :sent_at, :created_at, :updated_at
  end
end
