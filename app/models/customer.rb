class Customer < ActiveRecord::Base
  has_one  :profile, :as => :profilable
  has_many :members, :as => :memberable, :class_name => 'Membership'
  has_many :memberables, :as => :member, :class_name => 'Membership'
  has_many :customers,
    :through => :members,
    :source => :member,
    :source_type => 'Customer'
  has_many :users_units, :dependent => :destroy
  has_many :users,
    :through => :users_units
  has_one  :waiting_list, :dependent => :destroy
  has_many :waiting_users,
    :through => :waiting_list,
    :source => :users
  has_many :orders
  has_many :petitions, :as => :provider, :class_name => 'Order'

  validates :name, presence: true

  accepts_nested_attributes_for :users_units, :waiting_list
end
