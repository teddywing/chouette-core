class CleanLinesSecondaryCompanies < ActiveRecord::Migration
  def up
    Chouette::Line.where("secondary_company_ids = '{NULL}'").update_all secondary_company_ids: nil
  end
end
