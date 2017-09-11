RSpec.describe "routes for Routes", type: :routing do
  context "routes /referentials/:id/lines/:id/routes/:id/duplicate" do

    let( :controller ){ {controller: 'routes', referential_id: ':referential_id', line_id: ':line_id', id: ':id'}  }

    it 'with method post to #post_duplicate' do
      expect(
        post: '/referentials/:referential_id/lines/:line_id/routes/:id/duplicate'
      ).to route_to controller.merge(action: 'duplicate')
    end
  end
end
