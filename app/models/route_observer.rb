class RouteObserver < ActiveRecord::Observer
  observe Chouette::Route

  def after_save(route)
    Rails.logger.debug "after_save #{route.inspect}"
    if route.opposite_route_id
      Rails.logger.debug "dereference_opposite_route all routes except #{route.opposite_route_id}"
      route.line.routes.where("id <> ?", route.opposite_route_id).where(opposite_route_id: route).update_all(opposite_route_id: nil)
      Rails.logger.debug "reference_opposite_route #{route.opposite_route_id}"
      route.opposite_route.update_column :opposite_route_id, route
    else
      Rails.logger.debug "dereference_opposite_route all routes associated to #{route.id}"
      route.line.routes.where(opposite_route_id: route).update_all(opposite_route_id: nil)
    end
  end

  def before_destroy(route)
    Rails.logger.debug "after_destroy(#{route.inspect})"
    route.line.routes.where(opposite_route: route).update_all(opposite_route_id: nil)
  end
end
