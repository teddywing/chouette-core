var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')
var NavigateComponent = require('../components/Navigate')

const mapStateToProps = (state) => {
  return {
    vehicleJourneys: state.vehicleJourneys,
    status: state.status,
    pagination: state.pagination
  }
}


const Navigate = connect(mapStateToProps)(NavigateComponent)

module.exports = Navigate
