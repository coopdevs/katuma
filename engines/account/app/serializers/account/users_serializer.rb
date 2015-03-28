module Account
  class UsersSerializer < BaseSerializer

    schema do
      type 'users'

      collection :users, item, Account::UserSerializer
    end
  end
end
