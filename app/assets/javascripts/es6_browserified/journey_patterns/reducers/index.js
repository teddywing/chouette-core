var combineReducers = require('redux').combineReducers
var journeyPatterns = require('./journey_patterns')
var pagination = require('./pagination')

const journeyPatternsApp = combineReducers({
  journeyPatterns,
  pagination
})

module.exports = journeyPatternsApp
