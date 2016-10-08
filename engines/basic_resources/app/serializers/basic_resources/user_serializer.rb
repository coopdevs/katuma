module BasicResources
  class UserSerializer < Shared::BaseSerializer
    schema do
      type 'user'

      map_properties :id, :created_at, :updated_at
    end
  end
end
