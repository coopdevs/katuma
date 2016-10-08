module Products
  class User < ActiveRecord::Base

    self.table_name = :users

    include Shared::Model::ReadOnly
  end
end
