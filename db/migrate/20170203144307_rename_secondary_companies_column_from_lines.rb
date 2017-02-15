class RenameSecondaryCompaniesColumnFromLines < ActiveRecord::Migration
  def change
    rename_column :lines, :secondary_companies_ids, :secondary_company_ids
  end
end
