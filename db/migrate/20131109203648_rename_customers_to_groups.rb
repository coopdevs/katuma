class RenameCustomersToGroups < ActiveRecord::Migration
  def up
    rename_table :customers, :groups
    change_table :users_units do |t|
      t.rename :customer_id, :group_id
    end
    change_table :waiting_list_memberships do |t|
      t.rename :customer_id, :group_id
    end
  end
  def down
    rename_table :groups, :customers
    change_table :users_units do |t|
      t.rename :group_id, :customer_id
    end
    change_table :waiting_list_memberships do |t|
      t.rename :group_id, :customer_id
    end
  end
end
