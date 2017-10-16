class CreateReferentialSuiteForEachExistingWorkbench < ActiveRecord::Migration
  def up
    Workbench.where(output: nil).each do |workbench|
      workbench.output = ReferentialSuite.create
      workbench.save
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
