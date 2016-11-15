class RemoveKeepNetworksFromCleanUps < ActiveRecord::Migration
  def change
    remove_column :clean_ups, :keep_networks, :boolean
  end
end
