module Group
  class Group < ActiveRecord::Base

    self.table_name = :groups

    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships
    has_many :admins,
      -> { where "memberships.role = #{Role.new(:admin).index}" },
    through: :memberships,
      source: :user
    has_many :waiters,
      -> { where "memberships.role = #{Role.new(:waiters).index}" },
    through: :memberships,
      source: :user

    validates :name, presence: true
  end
end
