require 'spec_helper'

describe "/lines/show", :type => :view do

  assign_referential
  let!(:line) { assign :line, create(:line) }
  let!(:line_referential) { assign :line_referential, line.line_referential }
  let!(:routes) { assign :routes, Array.new(2) { create(:route, :line => line) }.paginate }
  let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }

  before do
    allow(view).to receive_messages(current_organisation: referential.organisation)
  end

  it "should render h1 with the line name" do
    render
    expect(rendered).to have_selector("h1", :text => Regexp.new(line.name))
  end

  # it "should display a map with class 'line'" do
  #   render
  #   expect(rendered).to have_selector("#map", :class => 'line')
  # end
  # FIXME #2018
  xit "should render a link to edit the line" do
    render
    expect(rendered).to have_selector("a[href='#{view.edit_line_referential_line_path(line_referential, line)}']")
  end

  it "should render a link to remove the line" do
    render
    expect(rendered).to have_selector("a[href='#{view.line_referential_line_path(line_referential, line)}']")
  end

end
