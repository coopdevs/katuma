class CreateUsersUnitMemberships < ActiveRecord::Migration
  def change
    create_table :users_unit_memberships do |t|
      t.integer :users_unit_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
    add_index :users_unit_memberships, :users_unit_id
    add_index :users_unit_memberships, :user_id
  end
end
