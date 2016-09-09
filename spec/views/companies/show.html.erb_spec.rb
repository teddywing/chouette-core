require 'spec_helper'

describe "/companies/show", :type => :view do

  let!(:company) { assign(:company, create(:company)) }
  let!(:line_referential) { assign :line_referential, company.line_referential }

  it "should render h2 with the company name" do
    render
    expect(rendered).to have_selector("h2", :text => Regexp.new(company.name))
  end

  # it "should display a map with class 'company'" do
  #   render
  #   rendered.should have_selector("#map", :class => 'company')
  # end

  it "should render a link to edit the company" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_line_referential_company_path(line_referential, company)}']")
  end

  it "should render a link to remove the company" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.line_referential_company_path(line_referential, company)}'][class='remove']")
  end

end

