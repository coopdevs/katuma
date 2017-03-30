class CreateOrderLine < ActiveRecord::Migration
  def change
    create_table :order_lines do |t|
      t.integer :unit, default: 1, null: false
      t.integer :quantity, null: false

      t.integer :order_id, null: false
      t.integer :product_id, null: false

      t.timestamps
    end

    add_index :order_lines, [:order_id, :product_id], unique: true
  end
end
