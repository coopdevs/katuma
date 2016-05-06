class AddGroupProducerUniqueIndexToSuppliers < ActiveRecord::Migration
  def change
    add_index :suppliers, [:group_id, :producer_id], { unique: true }
  end
end
