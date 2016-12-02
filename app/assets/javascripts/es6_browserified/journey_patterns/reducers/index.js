var combineReducers = require('redux').combineReducers
var journeyPatterns = require('./journey_patterns')

const journeyPatternsApp = combineReducers({
  journeyPatterns
})

module.exports = journeyPatternsApp
