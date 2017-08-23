class Api::V1::IbooController < Api::V1::ChouetteController
  protected
  def begin_of_association_chain
    @current_organisation
  end

  private
  def authenticate
    authenticate_with_http_basic do |code, token|
      if organisation = Organisation.find_by(code: code)
        if organisation.api_keys.exists?(token: token)
          @current_organisation = organisation
        end
      end
    end

    unless @current_organisation
      request_http_basic_authentication
    end
  end
end
