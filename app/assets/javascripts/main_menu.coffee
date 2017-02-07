@mainmenu = ->
  $('#main_nav').each ->
    # Opening/closing left-side menu
    $(this).on 'click', '.openMenu', (e) ->
      $(this).parent().addClass 'open'

    $(this).on 'click', '.closeMenu', (e) ->
      $(this).closest('.nav-menu').removeClass 'open'

    # Sticky behavior
    toStick = $('.page_header')
    limit = 51

    stickyContent = '<div class="sticky-content">'
    stickyContent += '<div class="sticky-ptitle">' + $(".page-title").html() + '</div>'
    stickyContent += '<div class="sticky-paction">' + $(".page-action").html() + '</div>'
    stickyContent += '</div>'

    $(document).on 'scroll', ->
      if $(window).scrollTop() >= limit
        $('#main_nav').addClass 'sticky'

        if $('#menu_top').find('.sticky-content').length == 0
          $('#menu_top').children('.menu-content').after(stickyContent)

      else
        $('#main_nav').removeClass 'sticky'

        if $('#menu_top').find('.sticky-content').length > 0
          $('.sticky-content').remove()

$(document).on 'ready page:load', mainmenu
