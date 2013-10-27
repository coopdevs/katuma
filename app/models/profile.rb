class Profile < ActiveRecord::Base
  belongs_to :profilable, :polymorphic => true

  validates :profilable_id, :profilable_type, :presence => true
end
