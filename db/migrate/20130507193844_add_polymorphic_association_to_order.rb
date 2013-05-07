class AddPolymorphicAssociationToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :orderable_id, :integer
    add_column :orders, :orderable_type, :string
    change_column :orders, :orderable_id, :integer, :null => false
    change_column :orders, :orderable_type, :string, :null => false
  end
end
