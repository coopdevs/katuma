class Profile < ActiveRecord::Base
  attr_accessible :description, :phone

  belongs_to :profilable, :polymorphic => true

  validates :profilable_id, :presence => true
end
