class Api::V1::IbooController < Api::V1::ChouetteController
  protected
  def begin_of_association_chain
    @current_organisation
  end

  private
  def authenticate
    authenticate_with_http_basic do |code, token|
      api_key = Api::V1::ApiKey.find_by(token: token)
      organisation = Organisation.find_by(code: code)

      return unless api_key && organisation

      if api_key.organisation == organisation
        @current_organisation = organisation
      end
    end

    unless @current_organisation
      request_http_basic_authentication
    end
  end
end
