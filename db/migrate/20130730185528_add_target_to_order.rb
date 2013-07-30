class AddTargetToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :target_id, :integer
  end
end
