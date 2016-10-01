module BasicResources
  class Producer < ActiveRecord::Base
    self.table_name = :producers

    has_many :memberships, dependent: :destroy, as: :basic_resource_producer

    validates :name, :email, :address, presence: true
  end
end
