class Customer < ActiveRecord::Base
  attr_accessible :name

  has_one :profile, :as => :profilable
  has_many :users, :as => :userable
  has_many :orders
  has_and_belongs_to_many :suppliers

  validates :name, :presence => true
end
