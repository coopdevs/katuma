class CreateWaitingLists < ActiveRecord::Migration
  def change
    create_table :waiting_lists do |t|
      t.integer :customer_id, :null => false

      t.timestamps
    end
  end
end
