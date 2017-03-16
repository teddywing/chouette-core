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

  data = ""
  $('.page-action').children().each ->
    data += $(this)[0].outerHTML

  # Sticky behavior
  $(document).on 'scroll', ->
    limit = 51

    stickyContent = '<div class="sticky-content">'
    stickyContent += '<div class="sticky-ptitle">' + $(".page-title").html() + '</div>'
    stickyContent += '<div class="sticky-paction">' + data + '</div>'
    stickyContent += '</div>'

    # console.log stickyContent

    if $(window).scrollTop() >= limit
      $('#main_nav').addClass 'sticky'

      if $('#menu_top').find('.sticky-content').length == 0
        $('#menu_top').children('.menu-content').after(stickyContent)
        $('.sticky-paction .small').after($('.formSubmitr'))

    else
      $('#main_nav').removeClass 'sticky'

      if $('#menu_top').find('.sticky-content').length > 0
        $('.page-action .small').after($('.formSubmitr'))
        $('.sticky-content').remove()
