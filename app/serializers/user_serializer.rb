class UserSerializer < BaseSerializer

  schema do
    type 'user'

    map_properties :id, :name, :email, :created_at, :updated_at
  end
end
