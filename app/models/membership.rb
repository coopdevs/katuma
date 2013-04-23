class Membership < ActiveRecord::Base
  attr_accessible :memberable_id, :memberable_type, :user_id

  belongs_to :user
  belongs_to :memberable, :polymorphic => true

  validates :memberable_id, :memberable_type, :user_id, :presence => true

end
