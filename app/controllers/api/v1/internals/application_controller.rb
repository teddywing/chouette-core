module Api
  module V1
    module Internals
      class ApplicationController < ActionController::Base
        respond_to :json
        layout false
        before_action :authenticate

        private
        def authenticate
          authenticate_with_http_token { |token| Rails.application.secrets.api_token == token }
        end
      end
    end
  end
end
