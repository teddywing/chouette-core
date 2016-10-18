module PathBuilderHelper

  # Companies
  def company_path(company)
    line_referential_company_path(company.line_referential_id, company)
  end
  def edit_company_path(company)
    edit_line_referential_company_path(company.line_referential_id, company)
  end

end
