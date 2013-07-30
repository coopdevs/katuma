class AddProductToOrderLine < ActiveRecord::Migration
  def change
    add_column :order_lines, :product_id, :integer
    change_column :order_lines, :product_id, :integer, :null => false
  end
end
