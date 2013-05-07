class Profile < ActiveRecord::Base
  attr_accessible :description, :phone

  belongs_to :profilable, :polymorphic => true

  validates :profilable_id, :profilable_type, :presence => true
end
