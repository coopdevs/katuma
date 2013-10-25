class Membership < ActiveRecord::Base
  attr_accessible :member, :memberable

  belongs_to :member, :polymorphic => true
  belongs_to :memberable, :polymorphic => true

  validates :member, :memberable,
              presence: true
  validates :member_id,
    uniqueness: {
      scope: [:memberable_id, :memberable_type]
    }
end
