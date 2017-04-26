fill_stop_points_options = ->
  stop_point_select = $('#routing_constraint_zone_stop_point_ids')
  stop_point_select.empty()
  referential_id = document.location.pathname.match(/\d+/g)[0]
  line_id = document.location.pathname.match(/\d+/g)[1]
  route_id = $('#routing_constraint_zone_route_id').val()

  if errors_on_form()
    stop_point_ids = eval($('#stop_point_ids').val())

  $.ajax
    url: "/referentials/#{referential_id}/lines/#{line_id}/routes/#{route_id}/stop_points"
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      for stop_point in data
        selected = $.inArray(stop_point.id, stop_point_ids) != -1
        stop_point_select.append "<option value='#{stop_point.id}'" + "#{if selected then ' selected' else ''}" + ">#{stop_point.name}</option>"
    error: (jqXHR, textStatus, errorThrown) ->
      console.log textStatus
      console.log errorThrown

errors_on_form = ->
  document.location.pathname.endsWith('routing_constraint_zones') && $('#new_routing_constraint_zone').length

$(document).on 'turbolinks:load', ->
  if document.location.pathname.endsWith('routing_constraint_zones/new') || errors_on_form()
    fill_stop_points_options()
  $('#routing_constraint_zone_route_id').change(fill_stop_points_options)
