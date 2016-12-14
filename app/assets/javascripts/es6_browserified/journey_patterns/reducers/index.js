var combineReducers = require('redux').combineReducers
var journeyPatterns = require('./journeyPatterns')
var pagination = require('./pagination')
var totalCount = require('./totalCount')

const journeyPatternsApp = combineReducers({
  journeyPatterns,
  pagination,
  totalCount
})

module.exports = journeyPatternsApp
