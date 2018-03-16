class AddCustomFieldValuesToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :custom_field_values, :json
  end
end
