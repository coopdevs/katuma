module BasicResources
  class Producer < ActiveRecord::Base
    self.table_name = :producers

    has_many :products
    has_many :memberships, dependent: :destroy

    validates :name, :email, :address, presence: true
  end
end
