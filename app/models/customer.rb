class Customer < ActiveRecord::Base
  attr_accessible :name

  has_one :profile, :as => :profilable
  has_many :members, :as => :memberable
  has_many :orders

  validates :name, :presence => true
end
