class AddIndexToWaitingList < ActiveRecord::Migration
  def change
    add_index :waiting_lists, :customer_id
  end
end
