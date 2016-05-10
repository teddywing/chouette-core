class CreateLineReferentials < ActiveRecord::Migration
  def change
    create_table :line_referentials do |t|
      t.string :name

      t.timestamps
    end
  end
end
