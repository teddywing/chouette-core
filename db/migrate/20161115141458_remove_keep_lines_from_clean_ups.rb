class RemoveKeepLinesFromCleanUps < ActiveRecord::Migration
  def change
    remove_column :clean_ups, :keep_lines, :boolean
  end
end
