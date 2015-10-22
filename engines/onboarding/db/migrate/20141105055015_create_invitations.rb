class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer  :group_id, null: false
      t.integer  :invited_by_id, null: false
      t.integer  :invited_user_id
      t.string   :email, null: false
      t.string   :token, null: false
      t.datetime :sent_at
      t.boolean  :accepted, null: false, default: false

      t.timestamps

      t.index    [:group_id, :invited_user_id]
    end
  end
end
