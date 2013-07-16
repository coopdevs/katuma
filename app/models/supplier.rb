class Supplier < ActiveRecord::Base
  attr_accessible :name

  has_one :profile, :as => :profilable
  has_many :members, :as => :memberable, :class_name => 'Membership'

  validates :name, :presence => true

  def member_list
    members = []
    self.members.each do |membership|
      members << membership.member
    end
    members
  end
end
