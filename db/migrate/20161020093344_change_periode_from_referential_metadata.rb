class ChangePeriodeFromReferentialMetadata < ActiveRecord::Migration
  def up
    change_column :referential_metadata, :periode, :daterange, array: true
    rename_column :referential_metadata, :periode, :periodes
  end

  def down
    rename_column :referential_metadata, :periodes, :periode
  end
end
