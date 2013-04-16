class AddPolymorphicAssociationToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :profilable_id, :integer
    add_column :profiles, :profilable_type, :string
    change_column :profiles, :profilable_id, :integer, :null => false
    change_column :profiles, :profilable_type, :string, :null => false
  end
end
