# $(document).on 'ready page:load', ->
#
#   link = []
#   $(document).on 'page:before-change', ->
#     link = []
#
#   $el = $('#main_nav')
#     # Opening/closing left-side menu
#   $el.find('.openMenu').on 'click', (e) ->
#     $(this).parent().addClass 'open'
#
#   $el.find('.closeMenu').on 'click', (e) ->
#     $(this).closest('.nav-menu').removeClass 'open'
#
#   # Opening menu panel according to current url
#   selectedItem = $el.find('.active')
#   selectedItem.closest('.panel-collapse').addClass 'in'
#   selectedItem.closest('.panel-title').children('a').attr('aria-expanded') == true
#
#
#   data = $('.page-action .small')[0].innerHTML
#
#   stickyContent = '<div class="sticky-content">'
#   stickyContent += '<div class="sticky-ptitle">' + $(".page-title").html() + '</div>'
#   stickyContent += '<div class="sticky-paction"><div class="small">' + data + '</div></div>'
#   stickyContent += '</div>'
#
#   # Sticky behavior
#   $(document).on 'scroll', ->
#     limit = 51
#
#     if $(window).scrollTop() >= limit
#       $('#main_nav').addClass 'sticky'
#
#       if $('#menu_top').find('.sticky-content').length == 0
#         $('#menu_top').children('.menu-content').after(stickyContent)
#         if link.length == 0
#           link = $('.page-action .small').next()
#         $('.sticky-paction .small').after(link)
#
#     else
#       $('#main_nav').removeClass 'sticky'
#
#       if $('#menu_top').find('.sticky-content').length > 0
#         $('.page-action .small').after(link)
#         $('.sticky-content').remove()
