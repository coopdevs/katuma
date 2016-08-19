module Account
  class UsersSerializer < ::Shared::BaseSerializer
    schema do
      type 'users'

      collection :users, item, Account::UserSerializer
    end
  end
end
