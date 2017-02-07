$(document).on 'ready page:load', ->
  $el = $('#main_nav')
    # Opening/closing left-side menu
  $el.find('.openMenu').on 'click', (e) ->
    $(this).parent().addClass 'open'

  $el.find('.closeMenu').on 'click', (e) ->
    $(this).closest('.nav-menu').removeClass 'open'

  # Opening menu panel according to current url
  selectedItem = $el.find('.active')
  selectedItem.closest('.panel-collapse').addClass 'in'
  selectedItem.closest('.panel-title').children('a').attr('aria-expanded') == true

  # Sticky behavior
  $(document).on 'scroll', ->
    limit = 51

    stickyContent = '<div class="sticky-content">'
    stickyContent += '<div class="sticky-ptitle">' + $(".page-title").html() + '</div>'
    stickyContent += '<div class="sticky-paction">' + $(".page-action").html() + '</div>'
    stickyContent += '</div>'

    if $(window).scrollTop() >= limit
      $('#main_nav').addClass 'sticky'

      if !$('#menu_top').find('.sticky-content')
        $('#menu_top').children('.menu-content').after(stickyContent)

    else
      $('#main_nav').removeClass 'sticky'

      if $('#menu_top').find('.sticky-content')
        $('.sticky-content').remove()
