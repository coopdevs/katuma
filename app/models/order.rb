class Order < ActiveRecord::Base
  attr_accessible :customer, :provider

  has_many :order_lines
  belongs_to :customer
  belongs_to :provider, :polymorphic => true

  validates :customer_id, :provider_id, :provider_type, :presence => true
  with_options :if => :provider_type_is_customer? do |order|
    order.validate :provider_is_not_customer,
                   :customer_is_member_of_provider
  end

  def provider_type_is_customer?
    provider_type == 'Customer'
  end

  # Check if the Customer is the same as Provider
  def provider_is_not_customer
    if provider_id == customer_id
      errors.add(:provider, "can't be the same as Customer")
    end
  end

  # Ensure that Customer is member of Provider
  def customer_is_member_of_provider
    if Membership.where(memberable_id: provider_id,
                        memberable_type: 'Customer',
                        member_id: customer_id,
                        member_type: 'Customer').empty?
      errors.add(:customer, "has to be a member of Provider")
    end
  end
end
