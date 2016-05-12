class AddUsernameToUsers < ActiveRecord::Migration
  def up
    add_column :users, :username, :string, :null => false
    add_index :users, :username, :unique => true
    User.all.each do |u|
      u.username = u.email
      u.save
    end
  end

  def down
    remove_column :users, :username, :string, :null => false
    remove_index :users, :username, :unique => true
  end
end
