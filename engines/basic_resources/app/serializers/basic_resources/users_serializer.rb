module BasicResources
  class UsersSerializer < Shared::BaseSerializer
    schema do
      type 'users'

      collection :users, item, BasicResources::UserSerializer
    end
  end
end
