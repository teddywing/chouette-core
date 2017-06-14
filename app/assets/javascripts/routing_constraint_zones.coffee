@ITL_stoppoints = ->
  routeID = $('#routing_constraint_zone_route_id').val()

  if (routeID)
    origin = window.location.origin
    path = window.location.pathname.split('/', 5).join('/')
    reqURL = origin + path + '/routes/' + routeID + '/stop_points.json'

    $.ajax
      url: reqURL
      dataType: 'json'
      error:  (jqXHR, textStatus, errorThrown) ->
        console.log(errorThrown)
      success: (collection, textStatus, jqXHR) ->
        html = ''
        stopAreaBaseURL = origin + window.location.pathname.split('/', 3).join('/') + '/stop_areas/'

        collection.forEach (item, index) ->
          html += "<div class='nested-fields'><div class='wrapper'>
          <div><a href='" + stopAreaBaseURL + item.stop_area_id + "' class='navlink' title='Voir l&#39;arrêt'><span>" + item.name + "</span></a></div>
          <div><span>" + item.city_name + " (" + item.zip_code + ")</span></div>
          <div>
            <span class='has_radio'>
              <input type='checkbox' name='routing_constraint_zone[stop_point_ids][" + index + "]' value='" + item.id + "'>
              <span class='radio-label'></span>
            </span>
          </div>
          </div></div>"

          $('#ITL_stoppoints').find('.nested-fields').remove()
          $('#ITL_stoppoints').find('.nested-head').after(html)

    # VALIDATION
    selection = []
    $('#ITL_stoppoints').on 'click', "input[type='checkbox']", (e) ->
      v = $(e.target).val()

      if ( $.inArray(v, selection) != -1 )
        selection.splice(selection.indexOf(v), 1)
      else
        selection.push(v)

    alertMsg = "<div class='alert alert-danger' style='margin-bottom:15px;'>
                  <p class='small'>Un ITL doit comporter au moins deux arrêts</p>
                </div>"

    $(document).on 'click', "input[type='submit']", (e)->
      inputName = $('#routing_constraint_zone_name').val()

      $('.alert-danger').remove()

      if ( selection.length < 2 && inputName != "")
        e.preventDefault()
        $('#routing_constraint_zone_name').closest('.form-group').removeClass('has-error').find('.help-block').remove()
        $('#ITL_stoppoints').prepend(alertMsg)

$ ->
  ITL_stoppoints()

  $('#routing_constraint_zone_route_id').on 'change', ->
    $('.alert-danger').remove()
    ITL_stoppoints()
