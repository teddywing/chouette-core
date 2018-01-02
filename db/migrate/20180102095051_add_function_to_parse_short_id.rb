class AddFunctionToParseShortId < ActiveRecord::Migration
  def up
    say "/!\\ /!\\ /!\\"
    say "Make sure you installed the extension first:"
    say "cd db/extensions/objectid; make install", :subitem
    say "/!\\ /!\\ /!\\"
    execute 'CREATE EXTENSION IF NOT EXISTS objectid SCHEMA shared_extensions;'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS objectid;'
  end
end
