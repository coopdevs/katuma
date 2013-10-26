class CreateUsersUnits < ActiveRecord::Migration
  def change
    create_table :users_units do |t|
      t.integer :customer_id, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    add_index :users_units, :customer_id
  end
end
