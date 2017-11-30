require 'spec_helper'

describe "/companies/show", :type => :view do

  let!(:company) { assign(:company, create(:company)) }
  let!(:line_referential) { assign :line_referential, company.line_referential }

  # it "should display a map with class 'company'" do
  #   render
  #  expect(rendered).to have_selector("#map", :class => 'company')
  # end
end
