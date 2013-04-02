class CreateOrderLines < ActiveRecord::Migration
  def change
    create_table :order_lines do |t|
      t.decimal :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
