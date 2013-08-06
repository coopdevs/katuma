class Order < ActiveRecord::Base
  attr_accessible :customer, :target

  has_many :order_lines
  belongs_to :customer
  belongs_to :target, :class_name => "Customer"

  validates :customer_id, :presence => true
  with_options :if => :target_id do |order|
    order.validate :target_is_not_customer,
                   :customer_is_member_of_target
  end

  def target_is_not_customer
    if target_id == customer_id
      errors.add(:target, "can't be the same as Customer")
    end
  end

  def customer_is_member_of_target
    if Membership.where(memberable_id: target_id,
                        memberable_type: 'Customer',
                        member_id: customer_id,
                        member_type: 'Customer').empty?
      errors.add(:customer, "has to be a member of Target")
    end
  end
end
