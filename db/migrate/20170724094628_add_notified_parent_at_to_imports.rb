class AddNotifiedParentAtToImports < ActiveRecord::Migration
  def change
    add_column :imports, :notified_parent_at, :datetime
  end
end
