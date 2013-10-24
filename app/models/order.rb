class Order < ActiveRecord::Base
  include Order::Validation

  attr_accessible :customer, :provider

  has_many :order_lines
  belongs_to :customer
  belongs_to :provider, :polymorphic => true
end
