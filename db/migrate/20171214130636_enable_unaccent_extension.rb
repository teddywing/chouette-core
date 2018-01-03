class EnableUnaccentExtension < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS unaccent SCHEMA shared_extensions;'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS unaccent SCHEMA shared_extensions;'
  end
end
