module TomTom
  class Matrix
    def initialize(connection)
      @connection = connection
    end

    def matrix(way_costs)
      points = points_from_way_costs(way_costs)
      points = points_as_params(points)

      response = @connection.post do |req|
        req.url '/routing/1/matrix/json'
        req.headers['Content-Type'] = 'application/json'

        req.params[:routeType] = 'shortest'
        req.params[:travelMode] = 'bus'

        req.body = {
          origins: points,
          destinations: points
        }.to_json
      end

      extract_costs_to_way_costs!(
        way_costs,
        points,
        JSON.parse(response.body)
      )
    end

    def points_from_way_costs(way_costs)
      points = Set.new

      way_costs.each do |way_cost|
        points.add(way_cost.departure)
        points.add(way_cost.arrival)
      end

      points
    end

    def points_as_params(points)
      points.map do |latlng|
        {
          point: {
            latitude: latlng.lat,
            longitude: latlng.lng
          }
        }
      end
    end

    # TODO: We actually need to create new WayCost objects to hold the new dot connections given to us by the matrix API.
    def extract_costs_to_way_costs!(way_costs, points, matrix_json)
      way_costs = []

      # `row` and `column` order is the same as `points`
      matrix_json['matrix'].each_with_index do |row, row_i|
        row.each_with_index do |column, column_i|
          next if column['statusCode'] != 200

          distance = column['response']['routeSummary']['lengthInMeters']

          # Ignore costs between a point and itself (e.g. from A to A)
          next if distance == 0

          departure = points[row_i]
          arrival = points[column_i]

          way_costs << WayCost.new(
            departure: Geokit::LatLng.new(
              departure[:point][:latitude],
              departure[:point][:longitude]
            ),
            arrival: Geokit::LatLng.new(
              arrival[:point][:latitude],
              arrival[:point][:longitude]
            ),
            distance: distance,
            time: column['response']['routeSummary']['travelTimeInSeconds']
            # id: 'TODO: figure out how to add combined stop IDs'
          )
        end
      end

      way_costs
    end
  end
end
