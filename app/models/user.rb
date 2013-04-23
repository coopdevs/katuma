class User < ActiveRecord::Base
  attr_accessible :email, :name

  has_one :profile, :as => :profilable
  has_many :orders, :as => :orderable
  has_many :memberships

  validates :email, :name, :presence => true
  validates :email, :uniqueness => true
end
