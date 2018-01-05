class AddModeToCleanUps < ActiveRecord::Migration
  def change
    add_column :clean_ups, :mode, :string
  end
end
