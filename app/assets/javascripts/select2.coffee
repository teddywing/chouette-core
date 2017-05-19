bind_select2 = (el, cfg = {}) ->
  target = $(el)
  default_cfg =
    theme: 'bootstrap'
    language: 'fr'
    placeholder: target.data('select2ed-placeholder')
    allowClear: true

  target.select2 $.extend({}, default_cfg, cfg)

bind_select2_ajax = (el, cfg = {}) ->
  target = $(el)
  cfg =
    ajax:
      data: (params) ->
        q:
          "#{target.data('term')}": params.term
      url: target.data('url'),
      dataType: 'json',
      delay: 125,
      processResults: (data, params) -> results: data
    minimumInputLength: 3
    templateResult: eval(target.data('formater'))
    templateSelection: (item) ->
      item.text

  bind_select2(el, cfg)

select2_time_table = (item) ->
  return item.text if item.loading
  wrap  = $('<div>', "class":'select2-result clearfix')
  wrap.html(["<h5>Time table : #{item.comment}</h5>"].join("\n"))

select2_calendar = (item) ->
  return item.text if item.loading
  wrap  = $('<div>', "class":'select2-result clearfix')
  wrap.html(["<h5>Calendar : #{item.name}</h5>"].join("\n"))


@select_2 = ->
  $("[data-select2ed='true']").each ->
    bind_select2(this)

  $("[data-select2-ajax='true']").each ->
    bind_select2_ajax(this)

  $('select.form-control.tags').each ->
    bind_select2(this, {tags: true})



$(document).on 'turbolinks:load', select_2
