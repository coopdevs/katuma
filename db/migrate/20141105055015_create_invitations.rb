class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer  :group_id, null: false
      t.integer  :invited_by, null: false
      t.string   :email, null: false
      t.datetime :sent_at

      t.timestamps

      t.index    :group_id
    end
  end
end
