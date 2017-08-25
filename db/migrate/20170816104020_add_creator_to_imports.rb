class AddCreatorToImports < ActiveRecord::Migration
  def change
    add_column :imports, :creator, :string
  end
end
