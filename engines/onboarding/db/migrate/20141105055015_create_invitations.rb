class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer  :group_id, null: false
      t.integer  :invited_by_id, null: false
      t.string   :email, null: false
      t.string   :token, null: false
      t.datetime :sent_at

      t.timestamps

      t.index    :token
    end
  end
end
