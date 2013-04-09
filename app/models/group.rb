class Group < ActiveRecord::Base
  attr_accessible :name

  has_one :profile, :as => :profilable
  has_many :users
  has_and_belongs_to_many :suppliers,
                          :class_name => "Group",
                          :foreign_key => "customer_id",
                          :association_foreign_id => "supplier_id"
  has_and_belongs_to_many :customers,
                          :class_name => "Group",
                          :foreign_key => "supplier_id",
                          :association_foreign_id => "customer_id"
  # In theory only customer type Groups should be
  # able to make orders and have prices,
  # so... let's see if we actually need
  # to split this class in two: Customer and Supplier,
  # maybe extending Group ActiveModel::Base class
  has_many :orders, :as => :orderable
  has_many :prices

  validates :name, :presence => true
end
