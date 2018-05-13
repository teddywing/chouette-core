module TomTom
  BASE_URL = 'https://api.tomtom.com'

  @@api_key = Rails.application.secrets.tomtom_api_key
  cattr_accessor :api_key

  def self.connection
    @connection ||= Faraday.new(
      url: BASE_URL,
      params: {
        key: api_key
      }
    ) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects, limit: 1
      faraday.adapter Faraday.default_adapter
    end
  end

  def self.enabled?
    api_key.present? && /[a-zA-Z0-9]{32}/ === api_key
  end

  def self.batch(way_costs)
    TomTom::Batch.new(connection).batch(way_costs)
  end

  def self.matrix(way_costs)
    TomTom::Matrix.new(connection).matrix(way_costs)
  end
end
