RSpec.describe "routes for Routes", type: :routing do
  it "routes to /referentials/:id/lines/:id/routes/:id/duplicate" do
    expect(
      get: '/referentials/:referential_id/lines/:line_id/routes/:id/duplicate'
    ).to be_routable

    expect(
      post: '/referentials/:referential_id/lines/:line_id/routes/:id/duplicate'
    ).to be_routable
  end
end
