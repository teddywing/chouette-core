RSpec.describe Devise::CasSessionsController, type: :controller do

  login_user

  context 'login is correctly redirected' do
    it 'to #service' do
      get :new
      expect(response).to redirect_to(unauthenticated_root_path)
    end
  end

  context 'user does not have any boiv:.+ permission' do
    it 'cannot login and will be redirected to the login page' do
      get :service
      expect(response).to redirect_to("http://stif-portail-dev.af83.priv/sessions/login?service=http%3A%2F%2Ftest.host%2Fusers%2Fservice")
    end
  end

  context 'user does have a boiv:.+ permission' do
    it 'can login and will be redirected to the referentials page' do
      @user.update_attribute :permissions, (@user.permissions << 'boiv:UnameIt')
      get :service
      expect(response).to redirect_to(authenticated_root_path)
    end
  end
end
