class AddImportXmlToLines < ActiveRecord::Migration
  def change
    add_column :lines, :import_xml, :text
  end
end
