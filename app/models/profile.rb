class Profile < ActiveRecord::Base
  attr_accessible :description, :phone

  belongs_to :profilable, :polymorphic => true

  validates :profilable_id, :profilabe_type, :presence => true
end
