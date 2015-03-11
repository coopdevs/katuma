module Account
  class User < ActiveRecord::Base

    self.table_name = :users

    has_secure_password

    validates :name,
      presence: true
    validates :email,
      presence: true,
      uniqueness: true

    has_many :memberships
    has_many :groups,
      through: :memberships
  end
end
