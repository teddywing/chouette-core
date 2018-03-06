class CleanFormerExports < ActiveRecord::Migration
  def change
    drop_table :exports
  end
end
