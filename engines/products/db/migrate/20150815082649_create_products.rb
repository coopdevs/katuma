class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, precision: 5, scale: 2, null: false
      t.integer :unit, null: false
      t.belongs_to :producer, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
