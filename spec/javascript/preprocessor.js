'use strict';

var coffee = require('coffeescript');

module.exports = {
  process: function(src, filename) {
    if (coffee.helpers.isCoffee(filename)) {
      return coffee.compile(src, {
        'bare': false,
        'inlineMap': true
      })
    }
    return src;
  }
};
