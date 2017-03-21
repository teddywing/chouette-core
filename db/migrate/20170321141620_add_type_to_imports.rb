class AddTypeToImports < ActiveRecord::Migration
  def up
    add_column :imports, :type, :string
    execute "update imports set type = 'netex_import' where type is null"
  end

  def down
    remove_column :imports, :type, :string
  end
end
