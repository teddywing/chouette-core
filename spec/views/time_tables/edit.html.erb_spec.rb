require 'spec_helper'

describe "/time_tables/edit", :type => :view do
  assign_referential
  let!(:time_table) { assign(:time_table, create(:time_table) ) }

  describe "test" do
    it "should render h1 with the group comment" do
      render
      expect(rendered).to have_selector("h1", :text => Regexp.new(time_table.comment))
    end
  end

  # No more test for the form, as it is now managed by React/Redux.
end
