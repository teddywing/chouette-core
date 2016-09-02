class AddImportXmlToAccessPoints < ActiveRecord::Migration
  def change
    add_column :access_points, :import_xml, :text
  end
end
