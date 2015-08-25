class CreateOrderLine < ActiveRecord::Migration
  def change
    create_table :order_lines do |t|
      t.integer :unit, default: 0, null: false
      t.integer :price, null: false
      t.integer :quantity, null: false

      t.references :order, index: true
      t.references :product, index: true
    end
  end
end
