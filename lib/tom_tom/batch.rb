module TomTom
  class Batch
    def initialize(connection)
      @connection = connection
    end

    def batch(way_costs)
      params = URI.encode_www_form({
        travelMode: 'bus',
        routeType: 'shortest'
      })
      batch_items = convert_way_costs(way_costs).map do |locations|
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

      extract_costs_to_way_costs!(
        way_costs,
        JSON.parse(response.body)
      )
    end

    def extract_costs_to_way_costs!(way_costs, batch_json)
      calculated_routes = batch_json['batchItems']
      calculated_routes.each_with_index do |route, i|
        next if route['statusCode'] != 200

        distance = route['response']['routes'][0]['summary']['lengthInMeters']
        time = route['response']['routes'][0]['summary']['travelTimeInSeconds']

        way_costs[i].distance = distance
        way_costs[i].time = time
      end

      way_costs
    end

    def convert_way_costs(way_costs)
      way_costs.map do |way_cost|
        "#{way_cost.departure.lat},#{way_cost.departure.lng}" \
        ":#{way_cost.arrival.lat},#{way_cost.arrival.lng}"
      end
    end
  end
end
