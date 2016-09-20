module Producers
  class Group < ActiveRecord::Base

    self.table_name = :groups

    include Shared::Model::ReadOnly
  end
end
