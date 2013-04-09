class User < ActiveRecord::Base
  attr_accessible :email, :name

  has_one :profile, :as => :profilable
  has_many :orders, :as => :orderable
  # this should be has_many_and_belongs_to or whatever...
  belongs_to :group

  validates :email, :name, :group_id, :presence => true
  validates :email, :uniqueness => true
end
