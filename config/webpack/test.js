const environment = require('./environment')

import $ from 'jquery';
global.$ = global.jQuery = $;

require('bootstrap')

module.exports = environment.toWebpackConfig()
