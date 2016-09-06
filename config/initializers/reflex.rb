if Rails.application.config.try(:reflex_api_url)
  Reflex::API.base_url = Rails.application.config.reflex_api_url
end
