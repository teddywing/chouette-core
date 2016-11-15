class RemoveKeepCompaniesFromCleanUps < ActiveRecord::Migration
  def change
    remove_column :clean_ups, :keep_companies, :boolean
  end
end
