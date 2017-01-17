var combineReducers = require('redux').combineReducers
var stopPoints = require('./stopPoints')
var olMap = require('./olMap')

const stopPointsApp = combineReducers({
  stopPoints,
  olMap
})

module.exports = stopPointsApp
