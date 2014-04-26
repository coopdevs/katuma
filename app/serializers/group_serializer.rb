class GroupSerializer < BaseSerializer

  schema do
    type 'group'

    map_properties :id, :name, :created_at, :updated_at
  end
end
