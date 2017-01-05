var combineReducers = require('redux').combineReducers
var journeyPatterns = require('./journeyPatterns')
var pagination = require('./pagination')
var totalCount = require('./totalCount')
var modal = require('./modal')
var confirmModal = require('./confirmModal')

const journeyPatternsApp = combineReducers({
  journeyPatterns,
  pagination,
  totalCount,
  modal,
  confirmModal
})

module.exports = journeyPatternsApp
