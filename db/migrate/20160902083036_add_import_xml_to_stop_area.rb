class AddImportXmlToStopArea < ActiveRecord::Migration
  def change
    add_column :stop_areas, :import_xml, :text
  end
end
