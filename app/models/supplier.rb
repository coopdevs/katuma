class Supplier < ActiveRecord::Base
  attr_accessible :name

  has_one :profile, :as => :profilable

  validates :name, :presence => true
end
