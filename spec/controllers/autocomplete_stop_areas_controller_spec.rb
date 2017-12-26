require 'rails_helper'

RSpec.describe AutocompleteStopAreasController, type: :controller do
  login_user

  let(:referential) { Referential.first }
  let!(:stop_area) { create :stop_area, name: 'écolà militaire' }

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
end
