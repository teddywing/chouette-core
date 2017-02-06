@selectTable = ->
  $('.table').each ->
    selection = []
    $(this).on 'click', "[type='checkbox']", (e)->
      if e.currentTarget.id == '0'
        if e.currentTarget.checked
          $("[type='checkbox']").each ->
            $(this).prop('checked', true)
            # Add each element to selection
            selection.push($(this).attr('id'))

          # Remove th checkbox from selection
          selection.splice(0, 1)

        else
          $("[type='checkbox']").each ->
            $(this).prop('checked', false)
          # Empty selection
          selection = []

      else
        if e.currentTarget.checked
          selection.push(e.currentTarget.id)
        else
          elm = selection.indexOf(e.currentTarget.id)
          selection.splice(elm, 1)

      # We log the selection (for now)
      console.log selection

$(document).on 'ready page:load', selectTable
