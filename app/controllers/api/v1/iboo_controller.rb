class Api::V1::IbooController < Api::V1::ChouetteController
  protected
  def begin_of_association_chain
    @current_organisation
  end

  private
  def authenticate
    authenticate_with_http_basic do |login, token|
      api_key = Api::V1::ApiKey.find_by(token: token)
      user = User.find_by(username: login)

      return unless api_key && user
      if api_key.organisation == user.organisation
        @current_user = user
        @current_organisation = user.organisation
      end
    end

    unless @current_user && @current_organisation
      request_http_basic_authentication
    end
  end
end
