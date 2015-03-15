module Account
  class User < ActiveRecord::Base

    self.table_name = :users

    has_secure_password

    validates :email,    presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
  end
end
