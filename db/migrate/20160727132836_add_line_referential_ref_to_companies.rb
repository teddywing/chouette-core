class AddLineReferentialRefToCompanies < ActiveRecord::Migration
  def change
    add_reference :companies, :line_referential, index: true
  end
end
