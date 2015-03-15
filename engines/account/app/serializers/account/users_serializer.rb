module Account
  class UsersSerializer < Account::BaseSerializer

    schema do
      type 'users'

      collection :users, item, Account::UserSerializer
    end
  end
end
