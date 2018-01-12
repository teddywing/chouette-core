RSpec.describe VehicleJourneysController, :type => :controller do

  before do
    @user = build_stubbed(:allmighty_user)
  end

  describe 'user_permissions' do
    let( :referential ){ build_stubbed(:referential) }
    let( :user_context ){ UserContext.new(@user, referential: referential) }

    before do
      allow(controller).to receive(:pundit_user).and_return(user_context)
      allow(controller).to receive(:current_organisation).and_return(@user.organisation)
    end

    it 'computes them correctly if not authorized' do
      expect( controller.send(:user_permissions) ).to eq({'vehicle_journeys.create'  => false,
                                                   'vehicle_journeys.destroy' => false,
                                                   'vehicle_journeys.update'  => false }.to_json)
    end
    it 'computes them correctly if authorized' do
      @user.organisation_id = referential.organisation_id
      expect( controller.send(:user_permissions) ).to eq({'vehicle_journeys.create'  => true,
                                                   'vehicle_journeys.destroy' => true,
                                                   'vehicle_journeys.update'  => true }.to_json)
    end
  end

end
