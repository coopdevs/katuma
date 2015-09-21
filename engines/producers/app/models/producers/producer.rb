module Producers
  class Producer < ActiveRecord::Base
    self.table_name = :producers

    has_many :products

    validates :name, :email, :address, presence: true
  end
end
