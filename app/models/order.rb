class Order < ActiveRecord::Base
  attr_accessible :customer, :target

  has_many :order_lines
  belongs_to :customer
  belongs_to :target, :class_name => "Customer"

  validates :customer_id, :presence => true
  validate :target_is_not_customer
  validate :customer_is_member_of_target

  def target_is_not_customer
    if target_id && target_id == customer_id
      errors.add(:target, "can't be the same as Customer")
    end
  end

  def customer_is_member_of_target
    if target_id # to be continued
      errors.add(:customer, "has to be a member of Customer")
    end
  end
end
