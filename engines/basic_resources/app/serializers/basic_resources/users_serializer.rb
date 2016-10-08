module BasicResources
  class UsersSerializer < Shared::BaseSerializer
    schema do
      type 'users'

      collection :users, item, UserSerializer
    end
  end
end
