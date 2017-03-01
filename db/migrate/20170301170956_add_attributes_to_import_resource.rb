class AddAttributesToImportResource < ActiveRecord::Migration
  def change
    add_column :import_resources, :type, :string
    add_column :import_resources, :reference, :string
    add_column :import_resources, :name, :string
    add_column :import_resources, :metrics, :hstore
  end
end
