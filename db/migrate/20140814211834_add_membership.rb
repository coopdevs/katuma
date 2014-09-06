class AddMembership < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false
      t.integer :role, null: false

      t.timestamps
    end
  end
end
