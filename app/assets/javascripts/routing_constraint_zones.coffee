$ ->

  update_stop_points = () ->
    url = $('#routing_constraint_zone_route_id').attr("data-url")
    routing_constraint_zone_json = $('#routing_constraint_zone_route_id').attr("data-object")
    route_id = $('#routing_constraint_zone_route_id').val()
    $.ajax
      url: url
      dataType: 'script'
      data: { route_id: route_id, routing_constraint_zone_json: routing_constraint_zone_json }
      error:  (jqXHR, textStatus, errorThrown) ->
        console.log("ERROR")
      success: (data, textStatus, jqXHR) ->
        console.log("SUCCESS")

  $("#itl_form #routing_constraint_zone_route_id").on 'change', -> update_stop_points()

  update_stop_points()
