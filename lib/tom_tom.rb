module TomTom
  BASE_URL = 'https://api.tomtom.com'
  API_KEY = Rails.application.secrets.tomtom_api_key

  @connection = Faraday.new(
    url: BASE_URL,
    params: {
      key: API_KEY
    }
  ) do |faraday|
    faraday.use FaradayMiddleware::FollowRedirects, limit: 1
    faraday.adapter Faraday.default_adapter
  end

  def self.batch(way_costs)
    TomTom::Batch.new(@connection).batch(way_costs)
  end
end
