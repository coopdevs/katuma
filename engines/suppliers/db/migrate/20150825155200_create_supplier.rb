class CreateSupplier < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.integer :group_id, null: false
      t.integer :producer_id, null: false

      t.timestamps
    end

    add_index :suppliers, [:group_id]
    add_index :suppliers, [:producer_id]
  end
end
