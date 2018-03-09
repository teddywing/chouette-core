class TomTom
  BASE_URL = 'https://api.tomtom.com'
# https://api.tomtom.com/routing/1/matrix/xml?key=<APIKEY>&routeType=shortest&travelMode=truck
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

  # Maximum size of matrix is 700 (number of origins multiplied by number of destinations), so examples of matrix dimensions are: 5x10, 10x10, 28x25 (it does not need to be square).
  # def matrix(opts)
  #   @connection.post do |req|
  #     req.url '/routing/1/matrix/json'
  #     req.params {
  #       routeType: 'shortest',
  #       travelMode: opts[:travel_mode],
  #       routingOption: 'TODO'
  #     }
  #     req.body {
  #       origins: [],
  #       destinations: []
  #     }
  #   )
  # end

# Maximum number of batch items is 700.
# {
#   "batchItems": [
#     {"query": "/calculateRoute/52.36006039665441,4.851064682006836:52.36187528311709,4.850560426712036/json?travelMode=car&routeType=shortest&traffic=true&departAt=now&maxAlternatives=0"},
#     {"query": "/calculateRoute/52.36241907934766,4.850034713745116:52.36173769505809,4.852169752120972/json?travelMode=teleport&routeType=shortest&traffic=true&departAt=now"}
#   ]
# }
  def batch(way_costs)
    # TODO: figure out param assembly (maybe Net::HTTP has something?)
    params = URI.encode_www_form({
      travelMode: 'car',
      routeType: 'shortest',
      traffic: 'true',
      departAt: 'now',
      maxAlternatives: 0
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
