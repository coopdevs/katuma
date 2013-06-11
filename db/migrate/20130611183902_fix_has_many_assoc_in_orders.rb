class FixHasManyAssocInOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :orderable_id
    remove_column :orders, :orderable_type
    add_column :orders, :customer_id, :integer
    change_column :orders, :customer_id, :integer, :null => false
  end
end
