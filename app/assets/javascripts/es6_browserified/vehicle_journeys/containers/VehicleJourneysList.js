var actions = require('../actions')
var connect = require('react-redux').connect
var VehicleJourneys = require('../components/VehicleJourneys')

const mapStateToProps = (state) => {
  return {
    vehicleJourneys: state.vehicleJourneys,
    status: state.status,
    filters: state.filters
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onLoadFirstPage: () =>{
      dispatch(actions.fetchingApi())
      actions.fetchVehicleJourneys(dispatch)
    },
    onUpdateTime: (e, subIndex, index, timeUnit, isDeparture) => {
      dispatch(actions.updateTime(e.target.value, subIndex, index, timeUnit, isDeparture))
    }
  }
}

const VehicleJourneysList = connect(mapStateToProps, mapDispatchToProps)(VehicleJourneys)

module.exports = VehicleJourneysList
