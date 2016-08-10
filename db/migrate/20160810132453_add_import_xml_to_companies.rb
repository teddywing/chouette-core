class AddImportXmlToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :import_xml, :text
  end
end
