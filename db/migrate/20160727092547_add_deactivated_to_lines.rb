class AddDeactivatedToLines < ActiveRecord::Migration
  def change
    add_column :lines, :deactivated, :boolean, default: false
  end
end
