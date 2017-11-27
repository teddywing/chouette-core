class AddObjectIdFormatToWorkbenches < ActiveRecord::Migration
  def change
    add_column :workbenches, :objectid_format, :string
  end
end
