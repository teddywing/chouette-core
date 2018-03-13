class StopAreasToWayCostsConverter
  def initialize(stop_areas)
    @stop_areas = stop_areas
  end

  def convert
    @stop_areas.each_cons(2).map do |stop_area_pair|
      WayCost.new(
        departure: Geokit::LatLng.new(
          stop_area_pair[0].latitude,
          stop_area_pair[0].longitude
        ),
        arrival: Geokit::LatLng.new(
          stop_area_pair[1].latitude,
          stop_area_pair[1].longitude
        ),
        id: "#{stop_area_pair[0].id}-#{stop_area_pair[1].id}"
      )
    end
  end
end
