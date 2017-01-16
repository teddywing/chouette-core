class GiveRoutesPermissionsToUsers < ActiveRecord::Migration
  def change
    User.find_each do |user|
      user.permissions =['routes.create', 'routes.edit', 'routes.destroy']
      user.save!
    end
  end
end
