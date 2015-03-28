module Account
  class UserSerializer < BaseSerializer
    schema do
      type 'user'

      map_properties :id, :full_name, :first_name, :last_name, :username, :email, :created_at, :updated_at
    end
  end
end
