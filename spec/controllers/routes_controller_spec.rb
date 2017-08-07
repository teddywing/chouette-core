RSpec.describe RoutesController, type: :controller do
  login_user

  let(:route) { create(:route) }

  it { is_expected.to be_kind_of(ChouetteController) }

  shared_examples_for "redirected to referential_line_path(referential,line)" do
    it "should redirect_to referential_line_path(referential,line)" do
      # expect(response).to redirect_to( referential_line_path(referential,route.line) )
    end
  end

  shared_examples_for "line and referential linked" do
    it "assigns route.line as @line" do
      expect(assigns[:line]).to eq(route.line)
    end

    it "assigns referential as @referential" do
      expect(assigns[:referential]).to eq(referential)
    end
  end

  shared_examples_for "route, line and referential linked" do
    it "assigns route as @route" do
      expect(assigns[:route]).to eq(route)
    end
    it_behaves_like "line and referential linked"
  end

  describe "GET /index" do
    before(:each) do
      get :index, line_id: route.line_id,
          referential_id: referential.id
    end

    it_behaves_like "line and referential linked"
    it_behaves_like "redirected to referential_line_path(referential,line)"
  end

  describe "POST /create" do
    before(:each) do
      post :create, line_id: route.line_id,
          referential_id: referential.id,
          route: { name: "changed"}

    end
    it_behaves_like "line and referential linked"
    it_behaves_like "redirected to referential_line_path(referential,line)"
  end

  describe "PUT /update" do
    before(:each) do
      put :update, id: route.id, line_id: route.line_id,
          referential_id: referential.id,
          route: route.attributes
    end

    it_behaves_like "route, line and referential linked"
    it_behaves_like "redirected to referential_line_path(referential,line)"
  end

  describe "GET /show" do
    before(:each) do
      get :show, id: route.id,
          line_id: route.line_id,
          referential_id: referential.id
    end

    it_behaves_like "route, line and referential linked"

    it "assigns RouteMap.new(route) as @map" do
      expect(assigns[:map]).to be_an_instance_of(RouteMap)
      expect(assigns[:map].route).to eq(route)
    end
  end

  describe "GET /duplicate" do
    it "returns success" do
      get :duplicate,
        referential_id: route.line.line_referential_id,
        line_id: route.line_id,
        id: route.id

      expect(response).to be_success
    end
  end

  describe "POST /duplicate" do
    it "creates a new route" do
      expect do
        post :duplicate,
          referential_id: route.line.line_referential_id,
          line_id: route.line_id,
          id: route.id,
          params: {
            name: '102 Route',
            published_name: '102 route'
          }
      end.to change { Chouette::Route.count }.by(1)

      expect(Chouette::Route.last.name).to eq('102 Route')
    end
  end
end
