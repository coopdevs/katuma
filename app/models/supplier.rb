class Supplier < ActiveRecord::Base
  attr_accessible :name

  has_one :profile, :as => :profilable
  has_many :members, :as => :memberable

  validates :name, :presence => true
end
