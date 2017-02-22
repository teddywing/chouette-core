require 'rails_helper'

RSpec.describe ImportsController, :type => :controller do
  login_user

  let(:workbench) { create :workbench }

  describe 'GET #new' do
    it 'should be successful' do
      get :new, workbench_id: workbench.id
      expect(response).to be_success
    end
  end
end
