var actions = require('../actions')
var connect = require('react-redux').connect
var VehicleJourneys = require('../components/VehicleJourneys')

const mapStateToProps = (state) => {
  return {
    vehicleJourneys: state.vehicleJourneys,
    status: state.status
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onLoadFirstPage: () =>{
      dispatch(actions.fetchingApi())
      actions.fetchVehicleJourneys(dispatch)
    }
  }
}

const VehicleJourneysList = connect(mapStateToProps, mapDispatchToProps)(VehicleJourneys)

module.exports = VehicleJourneysList
