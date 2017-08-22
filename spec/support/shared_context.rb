shared_context 'iboo authenticated api user' do
  let(:api_key) { create(:api_key) }

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(api_key.organisation.code, api_key.token)
  end
end
