(function() {
  //= require i18n
  var decorateI18n;

  decorateI18n = function(_i18n) {
    _i18n.tc = function(key, opts = {}) {
      var out;
      out = _i18n.t(key, opts);
      if (_i18n.locale === "fr") {
        out += " ";
      }
      return out + ":";
    };
    _i18n.model_name = function(model, opts = {}) {
      var last_key;
      last_key = opts.plural ? "other" : "one";
      return _i18n.t(`activerecord.models.${model}.${last_key}`);
    };
    _i18n.attribute_name = function(model, attribute, opts = {}) {
      return _i18n.t(`activerecord.attributes.${model}.${attribute}`);
    };
    _i18n.enumerize = function(enumerize, key, opts = {}) {
      return I18n.t(`enumerize.${enumerize}.${key}`);
    };
    return _i18n;
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = decorateI18n;
  }

  if (typeof I18n !== "undefined" && I18n !== null) {
    decorateI18n(I18n);
  }

}).call(this);
