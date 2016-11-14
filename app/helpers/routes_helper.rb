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
    route.stop_points.includes(:stop_area).map { |s| s.stop_area.attributes.slice("name","city_name", "zip_code").merge(stoppoint_id: s.id, stoparea_id: s.stop_area.id) }.to_json
  end

end
