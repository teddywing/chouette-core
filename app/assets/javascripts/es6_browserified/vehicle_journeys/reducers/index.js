var combineReducers = require('redux').combineReducers
var vehicleJourneys = require('./vehicleJourneys')
var pagination = require('./pagination')
var modal = require('./modal')
var status = require('./status')

const vehicleJourneysApp = combineReducers({
  vehicleJourneys,
  pagination,
  modal,
  status
})

module.exports = vehicleJourneysApp
