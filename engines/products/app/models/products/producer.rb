module Products
  class Producer < ActiveRecord::Base

    self.table_name = :producers

    include Shared::Model::ReadOnly
  end
end
