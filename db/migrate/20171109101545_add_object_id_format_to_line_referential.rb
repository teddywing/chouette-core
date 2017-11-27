class AddObjectIdFormatToLineReferential < ActiveRecord::Migration
  def change
    add_column :line_referentials, :objectid_format, :string
  end
end
