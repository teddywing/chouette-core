class DropTableRouteSections < ActiveRecord::Migration
  def change
    drop_table :route_sections
  end
end
