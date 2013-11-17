class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
    add_index :api_keys, :user_id
  end
end
