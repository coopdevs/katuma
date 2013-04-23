class Supplier < ActiveRecord::Base
  attr_accessible :name

  has_one :profile, :as => :profilable
  has_many :memberships, :as => :memberable

  validates :name, :presence => true
end
