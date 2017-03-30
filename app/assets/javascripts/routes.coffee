$(document).on("change", '#route_wayback', (e) ->
  way = if $(this).is(':checked') then "backward" else "straight_forward"
  $('.opposite_route').hide().find('select').prop('disabled', true)

  field = $(".opposite_route.#{way}")
  if field.length
    field.removeClass('hidden').show().find('select').prop('disabled', false)
)
