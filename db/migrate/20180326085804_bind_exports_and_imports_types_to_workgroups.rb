class BindExportsAndImportsTypesToWorkgroups < ActiveRecord::Migration
  def change
    add_column :workgroups, "import_types", :string, default: [], array: true
    add_column :workgroups, "export_types", :string, default: [], array: true
  end
end
