var combineReducers = require('redux').combineReducers
var journeyPatterns = require('./journeyPatterns')
var pagination = require('./pagination')
var modal = require('./modal')

const journeyPatternsApp = combineReducers({
  journeyPatterns,
  pagination,
  modal
})

module.exports = journeyPatternsApp
