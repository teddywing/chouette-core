require 'spec_helper'

describe "/line_referentials/show", :type => :view do

  let!(:line_referential) { assign :line_referential, create(:line_referential) }

  before :each do
    render
  end

  # FIXME See #6647
  # it "should not present syncing infos and button" do
  #   expect(view.content_for(:page_header_actions)).to_not have_selector("a[href=\"#{view.sync_line_referential_path(line_referential)}\"]")
  # end

  # with_permission "line_referentials.synchronize" do
  #   it "should present syncing infos and button" do
  #     expect(view.content_for(:page_header_actions)).to have_selector("a[href=\"#{view.sync_line_referential_path(line_referential)}\"]", count: 1)
  #   end
  # end
end
