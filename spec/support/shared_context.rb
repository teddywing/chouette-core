shared_context 'iboo authenticated api user' do
  let(:api_key) { create(:api_key) }
  let(:user)    { create(:user, organisation: api_key.organisation ) }

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.username, api_key.token)
  end
end
