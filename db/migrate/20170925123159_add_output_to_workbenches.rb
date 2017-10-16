class AddOutputToWorkbenches < ActiveRecord::Migration
  def change
    add_column :workbenches, :output_id, :bigint, index: true
  end
end
