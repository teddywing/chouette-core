class AddResourceAttributesToImportMessages < ActiveRecord::Migration
  def change
    add_column :import_messages, :resource_attributes, :hstore
  end
end
