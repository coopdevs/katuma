class WaitingList < ActiveRecord::Base
  attr_accessible :customer

  belongs_to :customer
  has_many :memberships, :as => :memberable
  has_many :users,
    :through => :memberships,
    :source => :member,
    :source_type => 'User'

  validates  :customer,
    presence: true
  validates  :customer_id,
    uniqueness: true
end
