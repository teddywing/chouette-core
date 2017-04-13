fill_stop_points_options = ->
  stop_point_select = $('#routing_constraint_zone_stop_point_ids')
  stop_point_select.empty()
  referential_id = document.location.pathname.match(/\d+/g)[0]
  line_id = document.location.pathname.match(/\d+/g)[1]
  route_id = $('#routing_constraint_zone_route_id').val()
  $.ajax
    url: "/referentials/#{referential_id}/lines/#{line_id}/routes/#{route_id}/stop_points"
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      for stop_point in data
        stop_point_select.append "<option value='#{stop_point.id}'>#{stop_point.name}</option>"
    error: (jqXHR, textStatus, errorThrown) ->
      console.log textStatus
      console.log errorThrown

$(document).on 'turbolinks:load', ->
  if document.location.pathname.endsWith('new')
    fill_stop_points_options()
  $('#routing_constraint_zone_route_id').change(fill_stop_points_options)

