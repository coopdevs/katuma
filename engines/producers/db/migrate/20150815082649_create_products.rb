class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.integer :unit, null: false
      t.references :provider, index: true

      t.timestamps
    end
  end
end
