class AddColumnOrderLineIdToOrderLine < ActiveRecord::Migration
  def change
    add_column :order_lines, :order_line_id, :integer
  end
end
