class AddOptionsToExports < ActiveRecord::Migration
  def change
    add_column :exports, :options, :hstore
  end
end
