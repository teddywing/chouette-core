class SetReferentialsReady < ActiveRecord::Migration
  def up
    Referential.update_all ready: true
  end

  def down
  end
end
