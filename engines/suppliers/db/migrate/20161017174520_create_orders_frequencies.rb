class CreateOrdersFrequencies < ActiveRecord::Migration
  def change
    create_table :orders_frequencies do |t|
      t.references :group, null: false, foreign_key: true, on_delete: :cascade
      t.text :frequency, null: false
      t.integer :frequency_type, null: false

      t.timestamps
    end

    add_index :orders_frequencies, [:group_id, :frequency_type], unique: true
  end
end
