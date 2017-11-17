class DropTableRuleParameterSets < ActiveRecord::Migration
  def change
    drop_table :rule_parameter_sets
  end
end
