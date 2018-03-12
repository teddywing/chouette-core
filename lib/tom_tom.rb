class TomTom
  BASE_URL = 'https://api.tomtom.com'
  API_KEY = Rails.application.secrets.tomtom_api_key

  def initialize
    @connection = Faraday.new(
      url: BASE_URL,
      params: {
        key: API_KEY
      }
    ) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects, limit: 1
      faraday.adapter Faraday.default_adapter
    end
  end

  def batch(way_costs)
    params = URI.encode_www_form({
      travelMode: 'bus',
      routeType: 'shortest'
    })
    batch_items = convert_way_costs_for_batch(way_costs).map do |locations|
      {
        query: "/calculateRoute/#{locations}/json?#{params}"
      }
    end

    response = @connection.post do |req|
      req.url '/routing/1/batch/json'
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        batchItems: batch_items
      }.to_json
    end
  end

  def convert_way_costs_for_batch(way_costs)
    way_costs.map do |way_cost|
      "#{way_cost.departure.lat},#{way_cost.departure.lng}" \
      ":#{way_cost.arrival.lat},#{way_cost.arrival.lng}"
    end
  end
end
