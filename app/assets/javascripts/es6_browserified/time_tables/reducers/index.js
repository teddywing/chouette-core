var combineReducers = require('redux').combineReducers
var status = require('./status')
var pagination = require('./pagination')
var modal = require('./modal')
var current_month = require('./current_month')
var periode_range = require('./periode_range')
var time_table_periods = require('./time_table_periods')
var day_types = require('./day_types')

const timeTablesApp = combineReducers({
  current_month,
  periode_range,
  time_table_periods,
  day_types,
  status,
  pagination,
  modal
})

module.exports = timeTablesApp
