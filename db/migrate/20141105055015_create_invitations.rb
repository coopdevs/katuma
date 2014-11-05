class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :group_id, null: false
      t.integer :user_id, null: false
      t.string :email, null: false
      t.boolean :accepted, default: false
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
