class RemoveCreatorFromImports < ActiveRecord::Migration
  def change
    remove_column :imports, :creator
  end
end
