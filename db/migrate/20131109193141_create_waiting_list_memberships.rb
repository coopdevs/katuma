class CreateWaitingListMemberships < ActiveRecord::Migration
  def change
    create_table :waiting_list_memberships do |t|
      t.integer :user_id, null: false
      t.integer :customer_id, null: false

      t.timestamps
    end
    add_index :waiting_list_memberships, :user_id
    add_index :waiting_list_memberships, :customer_id
  end
end
