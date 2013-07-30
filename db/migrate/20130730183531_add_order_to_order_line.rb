class AddOrderToOrderLine < ActiveRecord::Migration
  def change
    add_column :order_lines, :order_id, :integer
    change_column :order_lines, :order_id, :integer, :null => false
  end
end
