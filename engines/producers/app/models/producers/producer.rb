module Producers
  class Producer < ActiveRecord::Base
    self.table_name = :producers

    has_many :products
  end
end
