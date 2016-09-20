class CreateSupplier < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.references :group, null: false, foreign_key: true
      t.references :producer, null: false, foreign_key: true

      t.timestamps
    end

    add_index :suppliers, [:group_id, :producer_id], unique: true
  end
end
