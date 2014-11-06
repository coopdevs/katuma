class InvitationSerializer < BaseSerializer

  schema do
    type 'invitation'

    map_properties :id, :email, :group_id, :user_id, :accepted, :accepted_at, :created_at, :updated_at
  end
end
