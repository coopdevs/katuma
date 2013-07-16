class RecursiveCustomerAssociation < ActiveRecord::Migration
  def change
    remove_column :memberships, :user_id
    add_column :memberships, :member_id, :integer
    add_column :memberships, :member_type, :string
    change_column :memberships, :member_id, :integer, :null => false
    change_column :memberships, :member_type, :string, :null => false
  end
end
