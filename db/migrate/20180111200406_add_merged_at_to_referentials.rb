class AddMergedAtToReferentials < ActiveRecord::Migration
  def change
    add_column :referentials, :merged_at, :datetime
  end
end
