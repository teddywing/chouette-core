module Api
  module V1
    module Internals
      class ApplicationController < ActionController::Base
        inherit_resources
        respond_to :json
        layout false
        before_action :authenticate

        private
        def authenticate
          authenticate_with_http_token do |token, options|
            @current_organisation = Api::V1::ApiKey.find_by_token(token).try(:organisation)
          end
        end
      end
    end
  end
end
