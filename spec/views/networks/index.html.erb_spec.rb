require 'spec_helper'

describe "/networks/index", :type => :view do

  let!(:line_referential) { assign :line_referential, create(:line_referential) }
  let!(:networks) { assign :networks, Array.new(2){ create(:network, line_referential: line_referential) }.paginate }
  let!(:search) { assign :q, Ransack::Search.new(Chouette::Network) }

  # it "should render a show link for each group" do
  #   puts networks.inspect
  #   render
  #   networks.each do |network|
  #     expect(rendered).to have_selector("a[href='#{view.line_referential_network_path(line_referential, network)}']")
  #   end
  # end
  #
  # it "should render a link to create a new group" do
  #   render
  #   expect(view.content_for(:sidebar)).to have_selector("a[href='#{new_line_referential_network_path(line_referential)}']")
  # end

end
