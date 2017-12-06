shared_context 'iboo authenticated api user' do
  let(:api_key) { create(:api_key, organisation: organisation) }

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(api_key.organisation.code, api_key.token)
  end
end

shared_context 'iboo wrong authorisation api user' do
  let(:api_key) { create(:api_key, organisation: organisation) }

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('fake code', api_key.token)
  end
end

shared_context 'iboo authenticated internal api' do
  let(:api_key) { Rails.application.secrets.api_token }

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(api_key)
  end
end

shared_context 'iboo wrong authorisation internal api' do
  let(:api_key) { "false_api_token" }

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(api_key)
  end
end
