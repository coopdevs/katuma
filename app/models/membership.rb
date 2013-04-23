class Membership < ActiveRecord::Base
  attr_accessible :memberable, :user

  belongs_to :user
  belongs_to :memberable, :polymorphic => true

  validates :memberable_id, :memberable_type, :user_id, :presence => true

end
