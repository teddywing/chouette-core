require 'rails_helper'

RSpec.describe Api::V1::WorkbenchesController, type: :controller do
  context 'unauthenticated' do
    describe 'GET #index' do
      it 'should not be successful' do
        get :index
        expect(response).not_to be_success
      end
    end
  end

  context 'authenticated' do
    include_context 'iboo authenticated api user'

    describe 'GET #index' do
      it 'should be successful' do
        get :index
        expect(response).to be_success
      end
    end
  end
end
