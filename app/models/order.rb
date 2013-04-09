class Order < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :order_lines
  belongs_to :orderable, :polymorphic => true

  validates :orderable_id, :presence => true
end
