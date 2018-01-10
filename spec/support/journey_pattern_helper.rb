module Support
  module JourneyPatternHelper
    def generate_journey_pattern_costs distance, time
      costs = {}
      (journey_pattern.stop_points.size - 1).times do |i|
        start, finish = journey_pattern.stop_points[i..i+1]
        costs["#{start.id}-#{finish.id}"] = {
          distance: (distance.respond_to?(:call) ? distance.call(i) : distance),
          time: (time.respond_to?(:call) ? time.call(i) : time)
        }
      end
      costs
    end
  end
end

RSpec.configure do | config |
  config.include Support::JourneyPatternHelper, type: :model
end
