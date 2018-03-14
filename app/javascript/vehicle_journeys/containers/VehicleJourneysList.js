import actions from '../actions'
import { connect } from 'react-redux'
import VehicleJourneys from '../components/VehicleJourneys'

const mapStateToProps = (state) => {
  return {
    editMode: state.editMode,
    vehicleJourneys: state.vehicleJourneys,
    returnVehicleJourneys: state.returnVehicleJourneys,
    status: state.status,
    filters: state.filters,
    stopPointsList: state.stopPointsList,
    returnStopPointsList: state.returnStopPointsList
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onLoadFirstPage: (filters, routeUrl) =>{
      dispatch(actions.fetchingApi())
      actions.fetchVehicleJourneys(dispatch, undefined, undefined, filters.queryString, routeUrl)
    },
    onUpdateTime: (e, subIndex, index, timeUnit, isDeparture, isArrivalsToggled, enforceConsistency=false) => {
      dispatch(actions.updateTime(e.target.value, subIndex, index, timeUnit, isDeparture, isArrivalsToggled, enforceConsistency))
    },
    onSelectVehicleJourney: (index) => {
      dispatch(actions.selectVehicleJourney(index))
    }
  }
}

const VehicleJourneysList = connect(mapStateToProps, mapDispatchToProps)(VehicleJourneys)

export default VehicleJourneysList
