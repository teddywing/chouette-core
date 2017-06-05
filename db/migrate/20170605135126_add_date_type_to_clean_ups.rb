class AddDateTypeToCleanUps < ActiveRecord::Migration
  def change
    add_column :clean_ups, :date_type, :string
  end
end
