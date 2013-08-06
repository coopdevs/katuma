class Customer < ActiveRecord::Base
  attr_accessible :name

  has_one :profile, :as => :profilable
  has_many :members, :as => :memberable, :class_name => 'Membership'
  has_many :memberables, :as => :member, :class_name => 'Membership'
  has_many :orders
  has_many :petitions, :as => :provider, :class_name => 'Order'

  validates :name, :presence => true

  def member_list
    members = []
    self.members.each do |membership|
      members << membership.member
    end
    members
  end
end
