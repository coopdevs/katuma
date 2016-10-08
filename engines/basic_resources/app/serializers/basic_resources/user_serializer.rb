module BasicResources
  class UserSerializer < Shared::BaseSerializer
    schema do
      type 'user'

      map_properties :id, :email, :first_name, :last_name, :username,
        :created_at, :updated_at
    end
  end
end
