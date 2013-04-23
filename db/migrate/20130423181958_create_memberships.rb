class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id, :null => false
      t.integer :memberable_id, :null => false
      t.string :memberable_type, :null => false

      t.timestamps
    end
  end
end
