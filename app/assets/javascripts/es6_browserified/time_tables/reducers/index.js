var combineReducers = require('redux').combineReducers
var status = require('./status')
var pagination = require('./pagination')
var modal = require('./modal')
var timetable = require('./timetable')
var metas = require('./metas')

const timeTablesApp = combineReducers({
  timetable,
  metas,
  status,
  pagination,
  modal
})

module.exports = timeTablesApp
