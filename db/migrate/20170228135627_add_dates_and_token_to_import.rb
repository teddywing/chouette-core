class AddDatesAndTokenToImport < ActiveRecord::Migration
  def change
    add_column :imports, :started_at, :date
    add_column :imports, :ended_at, :date
    add_column :imports, :token_download, :string
  end
end
