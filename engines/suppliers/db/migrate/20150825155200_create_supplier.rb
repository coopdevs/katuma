class CreateSupplier < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.references :group, null: false, foreign_key: true
      t.references :producer, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :suppliers, [:group_id, :producer_id], unique: true
    add_index :suppliers, :deleted_at
  end
end
