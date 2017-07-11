RSpec.describe "/routes/show", type: :view do

  assign_referential
  let!(:line) { assign :line, create(:line) }
  let!(:route) { assign :route, create(:route, :line => line).decorate(context: {referential: referential, line: line }) }
  let!(:route_sp) { assign :route_sp, route.stop_points }

  before do
    self.params.merge!({
      id: route.id,
      line_id: line.id,
      referential_id: referential.id
    })
    allow(view).to receive(:current_referential).and_return(referential)
  end

  it "should render h1 with the route name" do
    render
    expect(rendered).to have_selector("h1", :text => Regexp.new(route.name))
  end

  it "should render a link to edit the route" do
    render
    expect(rendered).to have_selector("a[href='#{view.edit_referential_line_route_path(referential, line, route)}']")
  end

  it "should render a link to remove the route" do
    render
    expect(rendered).to have_selector("a[href='#{view.referential_line_route_path(referential, line, route)}']")
  end

end
