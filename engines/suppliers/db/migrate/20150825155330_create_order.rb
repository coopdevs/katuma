class CreateOrder < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.references :group, index: true
    end
  end
end
