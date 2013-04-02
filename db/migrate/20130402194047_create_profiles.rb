class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.text :description
      t.string :phone

      t.timestamps
    end
  end
end
