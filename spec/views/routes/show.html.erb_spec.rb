require 'spec_helper'

describe "/routes/show", :type => :view do

  # Fix tests to permit params to be used...

  # assign_referential
  # let!(:line) { assign :line, create(:line) }
  # let!(:route) { assign :route, create(:route, :line => line) }
  # let!(:route_sp) { assign :route_sp, route.stop_points }
  # let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }
  #
  #
  # before do
  #   self.params.merge!({
  #     id: route.id,
  #     line_id: line.id,
  #     referential_id: referential.id
  #   })
  # end

  # it "should render h1 with the route name" do
  #   render
  #   expect(rendered).to have_selector("h1", :text => Regexp.new(line.name))
  # end

  # it "should display a map with class 'line'" do
  #   render
  #   expect(rendered).to have_selector("#map", :class => 'line')
  # end

  # it "should render a link to edit the route" do
  #   render
  #   expect(rendered).to have_selector("a[href='#{view.edit_referential_line_route_path(referential, line, route)}']")
  # end
  #
  # it "should render a link to remove the route" do
  #   render
  #   expect(rendered).to have_selector("a[href='#{view.referential_line_route_path(referential, line, route)}']")
  # end

end
