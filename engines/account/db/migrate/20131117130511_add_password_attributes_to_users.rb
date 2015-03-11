class AddPasswordAttributesToUsers < ActiveRecord::Migration
  def up
    add_column :users, :password_digest, :string

    User.all.find_each do |user|
      user.password = 'secret'
      user.password_confirmation = 'secret'
      user.save!
    end

    change_column :users, :password_digest, :string, null: false
  end

  def down
    remove_column :users, :password_digest
  end
end
