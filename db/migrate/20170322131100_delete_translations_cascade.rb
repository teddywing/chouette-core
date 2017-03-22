class DeleteTranslationsCascade < ActiveRecord::Migration
  def change
    drop_table :translations, force: :cascade
  end
end
