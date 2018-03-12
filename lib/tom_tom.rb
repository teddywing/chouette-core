class TomTom
  BASE_URL = 'https://api.tomtom.com'
  API_KEY = ''

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

  def calculate_route(way_costs)
    params = URI.encode_www_form({
      travelMode: 'bus',
      routeType: 'shortest'
    })
    locations = convert_way_costs_for_calculate_route(way_costs)

    response = @connection.post do |req|
      req.url "/routing/1/calculateRoute/#{locations}/json?#{params}"
      req.headers['Content-Type'] = 'application/json'
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

    calculated_routes.each do |route|
      next if route['statusCode'] != 200

      distance = route['response']['routes']
    end
  end

  def convert_way_costs_for_batch(way_costs)
    way_costs.map do |way_cost|
      "#{way_cost.departure.lat},#{way_cost.departure.lng}" \
      ":#{way_cost.arrival.lat},#{way_cost.arrival.lng}"
    end
  end

  def convert_way_costs_for_calculate_route(way_costs)
    coordinates = []

    way_costs.map do |way_cost|
      coordinates << "#{way_cost.departure.lat},#{way_cost.departure.lng}"
      coordinates << "#{way_cost.arrival.lat},#{way_cost.arrival.lng}"
    end

    coordinates
      .uniq
      .join(':')
  end
end
