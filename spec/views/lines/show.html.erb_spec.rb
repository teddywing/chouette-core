require 'spec_helper'

describe "/lines/show", :type => :view do

  assign_referential
  let!(:line) do
    line = create(:line)
    assign :line, line.decorate(context: {
      line_referential: line.line_referential,
      current_organisation: referential.organisation
    })
  end
  let!(:line_referential) { assign :line_referential, line.line_referential }
  let!(:routes) { assign :routes, Array.new(2) { create(:route, :line => line) }.paginate }
  let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }

  before do
    allow(view).to receive_messages(current_organisation: referential.organisation)
  end
end
