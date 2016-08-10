class AddImportXmlToGroupOfLines < ActiveRecord::Migration
  def change
    add_column :group_of_lines, :import_xml, :text
  end
end
