var combineReducers = require('redux').combineReducers
var status = require('./status')
var journeyPatterns = require('./journeyPatterns')
var pagination = require('./pagination')
var modal = require('./modal')

const journeyPatternsApp = combineReducers({
  status,
  journeyPatterns,
  pagination,
  modal
})

module.exports = journeyPatternsApp
