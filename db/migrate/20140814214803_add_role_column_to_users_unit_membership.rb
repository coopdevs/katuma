class AddRoleColumnToUsersUnitMembership < ActiveRecord::Migration
  def change
    add_column :users_unit_memberships, :role, :integer, null: false
  end
end
