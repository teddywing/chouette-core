require 'rails_helper'

RSpec.describe Api::V1::ImportsController, type: :controller do
  let(:workbench) { create :workbench, organisation: organisation }

  context 'unauthenticated' do
    include_context 'iboo wrong authorisation api user'

    describe 'GET #index' do
      it 'should not be successful' do
        get :index, workbench_id: workbench.id
        expect(response).not_to be_success
      end
    end
  end

  context 'authenticated' do
    include_context 'iboo authenticated api user'

    describe 'GET #index' do
      it 'should be successful' do
        get :index, workbench_id: workbench.id
        expect(response).to be_success
      end
    end

    describe 'POST #create' do
      let(:file) { fixture_file_upload('multiple_references_import.zip') }

      it 'should be successful' do
        expect {
          post :create, workbench_id: workbench.id, workbench_import: {name: "test", file: file, creator: 'test'}, format: :json
        }.to change{WorkbenchImport.count}.by(1)
        expect(response).to be_success
      end
    end
  end
end
