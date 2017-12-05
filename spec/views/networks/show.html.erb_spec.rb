require 'spec_helper'

describe "/networks/show", :type => :view do

  let!(:network) do
    network = create(:network)
    assign(:network, network.decorate(context: {
      line_referential: network.line_referential
    }))
  end
  let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }
  let!(:line_referential) { assign :line_referential, network.line_referential }

  # it "should display a map with class 'network'" do
  #   render
  #   expect(rendered).to have_selector("#map")
  # end
end
