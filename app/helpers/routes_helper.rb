module RoutesHelper

  def line_formatted_name( line)
    return line.published_name if line.number.blank?
    "#{line.published_name} [#{line.number}]"
  end

  def fonticon_wayback(wayback)
    if wayback == 'straight_forward'
      return '<i class="fa fa-arrow-right"></i>'.html_safe
    else
      return '<i class="fa fa-arrow-left"></i>'.html_safe
    end
  end

  def route_json_for_edit(route)
    route.stop_points.includes(:stop_area).map do |stop_point|
      stop_area_attributes = stop_point.stop_area.attributes.slice("name","city_name", "zip_code", "user_objectid")
      stop_point_attributes = stop_point.attributes.slice("for_boarding","for_alighting")
      stop_area_attributes.merge(stop_point_attributes).merge(stoppoint_id: stop_point.id, stoparea_id: stop_point.stop_area.id)
    end.to_json
  end

end
