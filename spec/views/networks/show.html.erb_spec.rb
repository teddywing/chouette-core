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

  it "should render h1 with the network name" do
    render
    expect(rendered).to have_selector("h1", :text => Regexp.new(network.name))
  end

  # it "should display a map with class 'network'" do
  #   render
  #   expect(rendered).to have_selector("#map")
  # end

  it "should render a link to edit the network" do
    render
    expect(rendered).to have_selector("a[href='#{view.edit_line_referential_network_path(line_referential, network)}']")
  end

  it "should render a link to remove the network" do
    render
    expect(rendered).to have_selector("a[href='#{view.line_referential_network_path(line_referential, network)}']")
  end

end
