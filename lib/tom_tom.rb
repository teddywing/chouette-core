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

    response = JSON.parse(response.body)

    calculated_routes = response['batchItems']
    calculated_routes.each_with_index do |route, i|
      next if route['statusCode'] != 200

      distance = route['response']['routes'][0]['summary']['lengthInMeters']
      time = route['response']['routes'][0]['summary']['travelTimeInSeconds']

      way_costs[i].distance = distance
      way_costs[i].time = time
    end

    way_costs
  end

  def convert_way_costs_for_batch(way_costs)
    way_costs.map do |way_cost|
      "#{way_cost.departure.lat},#{way_cost.departure.lng}" \
      ":#{way_cost.arrival.lat},#{way_cost.arrival.lng}"
    end
  end
end
