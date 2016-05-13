require 'spec_helper'

describe "/lines/index", :type => :view do

  let!(:line_referential) { assign :line_referential, create(:line_referential) }
  let!(:network) { create :network }
  let!(:company) { create :company }
  let!(:lines) { assign :lines, Array.new(2) { create(:line, line_referential: line_referential, network: network, company: company) }.paginate }
  let!(:q) { assign :q, Ransack::Search.new(Chouette::Line) }

  before :each do
    allow(view).to receive(:link_with_search).and_return("#")
  end

  it "should render a show link for each group" do
    render
    lines.each do |line|
      expect(rendered).to have_selector(".line a[href='#{view.line_referential_line_path(line_referential, line)}']", :text => line.name)
    end
  end

  it "should render a link to create a new group" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_line_referential_line_path(line_referential)}']")
  end

end
