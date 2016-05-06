class AddForeignKeysToSuppliers < ActiveRecord::Migration
  def change
    add_foreign_key :suppliers, :groups, on_delete: :nullify
    add_foreign_key :suppliers, :producers, on_delete: :nullify
  end
end
