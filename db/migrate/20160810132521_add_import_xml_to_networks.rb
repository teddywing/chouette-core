class AddImportXmlToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :import_xml, :text
  end
end
