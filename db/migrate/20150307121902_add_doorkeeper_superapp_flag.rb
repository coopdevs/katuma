class AddDoorkeeperSuperappFlag < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :superapp, :boolean, default: false
  end
end
