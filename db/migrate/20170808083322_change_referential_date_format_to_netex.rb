class ChangeReferentialDateFormatToNetex < ActiveRecord::Migration
  def up
    execute "UPDATE referentials SET data_format = 'netex'"
  end

  def down
    execute "UPDATE referentials SET data_format = 'neptune'"
  end
end
