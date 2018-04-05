class ChangeCompaniesCustomFieldsValuesType < ActiveRecord::Migration
  def change
     change_column :companies, :custom_field_values, :jsonb
  end
end
