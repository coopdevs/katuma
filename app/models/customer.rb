class Customer < ActiveRecord::Base
  attr_accessible :name

  has_one :profile, :as => :profilable
  has_many :memberships, :as => :memberable
  has_many :orders, :as => :orderable

  validates :name, :presence => true

  def members
    members = []
    self.memberships.each do |membership|
      members << membership.user
    end
    members
  end
end
