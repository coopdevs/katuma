class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.string :email, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end
