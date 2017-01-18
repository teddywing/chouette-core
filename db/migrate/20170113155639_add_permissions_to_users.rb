class AddPermissionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :permissions, :string, array: true
  end
end
