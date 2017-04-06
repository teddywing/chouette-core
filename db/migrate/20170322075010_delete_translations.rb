class DeleteTranslations < ActiveRecord::Migration
  def change
    if table_exists?('translations')
      drop_table :translations
    end
  end
end
