class Membership < ActiveRecord::Base
  attr_accessible :member, :memberable

  belongs_to :member, :polymorphic => true
  belongs_to :memberable, :polymorphic => true

  validates :memberable_id, :memberable_type, :presence => true
  validates :member_id, :member_type, :presence => true
end
