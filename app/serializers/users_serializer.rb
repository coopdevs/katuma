class UsersSerializer < BaseSerializer

  schema do
    type 'users'

    collection :users, item, UserSerializer
  end
end
