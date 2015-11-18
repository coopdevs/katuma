class CreateOrder < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false

      t.timestamps
    end

    add_index :orders, [:user_id]
    add_index :orders, [:group_id]
  end
end
