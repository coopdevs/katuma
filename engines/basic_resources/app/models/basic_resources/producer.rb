module BasicResources
  class Producer < ActiveRecord::Base
    self.table_name = :producers

    has_many :memberships, dependent: :destroy, foreign_key: :basic_resource_producer_id

    validates :name, :email, :address, presence: true
  end
end
