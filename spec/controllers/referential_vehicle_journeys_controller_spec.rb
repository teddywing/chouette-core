require "rails_helper"

RSpec.describe ReferentialVehicleJourneysController, type: :controller do
  login_user

  before do
    @user.organisation.update features: %w{referential_vehicle_journeys}
  end

  describe 'GET #index' do
    it 'should be successful' do
      get :index, referential_id: referential
      expect(response).to be_success
    end

    it "refuse access when organisation does not have the feature 'referential_vehicle_journeys'" do
      @user.organisation.update features: []

      expect do
        get :index, referential_id: referential
      end.to raise_error(FeatureChecker::NotAuthorizedError)
    end

    it 'define Ransack search (alias @q)' do
      get :index, referential_id: referential
      expect(assigns[:q]).to be_an_instance_of(Ransack::Search)
    end

    it 'define @vehicle_journeys collection' do
      vehicle_journey = FactoryGirl.create :vehicle_journey
      get :index, referential_id: referential
      expect(assigns[:vehicle_journeys]).to include(vehicle_journey)
    end

    it 'paginage @vehicle_journeys collection' do
      FactoryGirl.create :vehicle_journey

      get :index, referential_id: referential
      expect(assigns[:vehicle_journeys].total_entries).to be(1)
    end
  end

end
