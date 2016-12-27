require 'rails_helper'

RSpec.describe ImportsController, :type => :controller do
  login_user

  describe 'GET #new' do
    it 'should be successful' do
      get :new, referential_id: referential.id
      expect(response).to be_success
    end
  end
end
