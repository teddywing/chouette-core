require 'spec_helper'

describe "/connection_links/show", :type => :view do

  assign_referential
  let!(:connection_link) { assign(:connection_link, create(:connection_link)) }
  let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }

  before do
    allow(view).to receive_messages(current_organisation: referential.organisation)
  end

  it "should render h2 with the connection_link name" do
    render
    expect(rendered).to have_selector("h2", :text => Regexp.new(connection_link.name))
  end

  with_permission "connection_links.update" do
    it "should render a link to edit the connection_link" do
      render
      expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_connection_link_path(referential, connection_link)}']")
    end
  end

  with_permission "connection_links.destroy" do
    it "should render a link to remove the connection_link" do
      render
      expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_connection_link_path(referential, connection_link)}'][class='remove']")
    end
  end

end
