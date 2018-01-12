require 'rails_helper'

RSpec.describe AutocompleteStopAreasController, type: :controller do
  login_user

  let(:referential) { Referential.first }
  let!(:stop_area) { create :stop_area, name: 'écolà militaire' }
  let!(:zdep_stop_area) { create :stop_area, area_type: "zdep" }
  let!(:not_zdep_stop_area) { create :stop_area, area_type: "lda" }

  describe 'GET #index' do
    it 'should be successful' do
      get :index, referential_id: referential.id
      expect(response).to be_success
    end

    context 'search by name' do
      it 'should be successful' do
        get :index, referential_id: referential.id, q: 'écolà', :format => :json
        expect(response).to be_success
        expect(assigns(:stop_areas)).to eq([stop_area])
      end

      it 'should be accent insensitive' do
        get :index, referential_id: referential.id, q: 'ecola', :format => :json
        expect(response).to be_success
        expect(assigns(:stop_areas)).to eq([stop_area])
      end
    end
  end

  context "when searching from the route editor" do
    let(:scope) { :route_editor }
    let(:request){
      get :index, referential_id: referential.id, scope: scope
    }
    it "should filter stop areas based on type" do
      request
      expect(assigns(:stop_areas)).to include(zdep_stop_area)
      expect(assigns(:stop_areas)).to_not include(not_zdep_stop_area)
    end

    with_feature :route_stop_areas_all_types do
      it "should not filter stop areas based on type" do
        request
        expect(assigns(:stop_areas)).to include(zdep_stop_area)
        expect(assigns(:stop_areas)).to include(not_zdep_stop_area)
      end
    end
  end


end
