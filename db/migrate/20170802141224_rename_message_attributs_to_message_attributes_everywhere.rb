class RenameMessageAttributsToMessageAttributesEverywhere < ActiveRecord::Migration
  def change
    # -- for table in cleanup_results  import_messages line_referential_sync_messages stop_area_referential_sync_messages
    # rename_column :table, :message_attributs, :message_attributes
    # rename_column :cleanup_results, :message_attributs, :message_attributes 
    rename_column :import_messages, :message_attributs, :message_attributes
    rename_column :line_referential_sync_messages, :message_attributs, :message_attributes
    rename_column :stop_area_referential_sync_messages, :message_attributs, :message_attributes
  end
end
