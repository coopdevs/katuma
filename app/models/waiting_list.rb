class WaitingList < ActiveRecord::Base
  belongs_to :customer
  has_many :memberships, :as => :memberable
  has_many :users,
    :through => :memberships,
    :source => :member,
    :source_type => 'User',
    :dependent => :restrict_with_error

  accepts_nested_attributes_for :users

  validates  :customer,
    presence: true
  validates  :customer_id,
    uniqueness: true
end
