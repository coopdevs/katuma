class User < ActiveRecord::Base
  has_one  :profile, :as => :profilable
  has_many :memberships, :as => :member
  has_many :users_units,
    :through => :memberships,
    :source => :memberable,
    :source_type => 'UsersUnit'
  has_many :customers, :through => :users_units
  has_many :waiting_lists,
    :through => :memberships,
    :source => :memberable,
    :source_type => 'WaitingList'

  validates :name, presence: true
  validates :email,
    presence: true,
    uniqueness: true
end
