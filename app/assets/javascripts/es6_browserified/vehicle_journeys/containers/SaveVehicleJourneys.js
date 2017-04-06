var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')
var SaveVehicleJourneysComponent = require('../components/SaveVehicleJourneys')

const mapStateToProps = (state) => {
  return {
    vehicleJourneys: state.vehicleJourneys,
    page: state.pagination.page,
    status: state.status,
    filters: state.filters
  }
}

const SaveVehicleJourneys = connect(mapStateToProps)(SaveVehicleJourneysComponent)

module.exports = SaveVehicleJourneys
