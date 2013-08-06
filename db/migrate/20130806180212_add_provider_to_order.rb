class AddProviderToOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :target_id, :integer
    add_column :orders, :provider_id, :integer
    add_column :orders, :provider_type, :string
    change_column :orders, :provider_id, :integer, :null => false
    change_column :orders, :provider_type, :string, :null => false
  end
end
