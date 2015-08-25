class CreateSupplier < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.references :group, index: true
      t.references :producer, index: true
    end
  end
end
