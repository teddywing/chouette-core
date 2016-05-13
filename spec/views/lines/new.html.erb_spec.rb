require 'spec_helper'

describe "/lines/new", :type => :view do

  let!(:network) { create(:network) }
  let!(:company) { create(:company) }
  let!(:line) { assign(:line, build(:line, :network => network, :company => company )) }
  let!(:line_referential) { assign :line_referential, line.line_referential }

  describe "form" do

    it "should render input for name" do
      render
      expect(rendered).to have_selector("form") do
        with_selector "input[type=text][name=?]", line.name
      end
    end

  end
end
