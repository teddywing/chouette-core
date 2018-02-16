#= require i18n

decorateI18n = (_i18n)->
  _i18n.tc = (key, opts={}) ->
    out = _i18n.t(key, opts)
    out += " " if _i18n.locale == "fr"
    out + ":"

  _i18n.model_name = (model, opts={}) ->
    last_key = if opts.plural then "other" else "one"
    _i18n.t("activerecord.models.#{model}.#{last_key}")

  _i18n.attribute_name = (model, attribute, opts={}) ->
    _i18n.t("activerecord.attributes.#{model}.#{attribute}")

  _i18n.enumerize = (enumerize, key, opts={}) ->
    I18n.t("enumerize.#{enumerize}.#{key}")

  _i18n

module?.exports = decorateI18n

if I18n?
  decorateI18n(I18n)
