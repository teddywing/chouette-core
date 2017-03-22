var combineReducers = require('redux').combineReducers
var stopPoints = require('./stopPoints')

const stopPointsApp = combineReducers({
  stopPoints
})

module.exports = stopPointsApp
