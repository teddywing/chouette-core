require 'spec_helper'

describe "/stop_area_referentials/show", :type => :view do

  let!(:stop_area_referential) { assign :stop_area_referential, create(:stop_area_referential) }

  before :each do
    render
  end

  # FIXME See #6647
  # it "should not present syncing infos and button" do
  #   expect(view.content_for(:page_header_actions)).to_not have_selector("a[href=\"#{view.sync_stop_area_referential_path(stop_area_referential)}\"]")
  # end

  # with_permission "stop_area_referentials.synchronize" do
  #   it "should present syncing infos and button" do
  #     expect(view.content_for(:page_header_actions)).to have_selector("a[href=\"#{view.sync_stop_area_referential_path(stop_area_referential)}\"]", count: 1)
  #   end
  # end
end
