import actions from '../../actions'
import { connect } from 'react-redux'
import ShiftVJComponent from '../../components/tools/ShiftVehicleJourney'

const mapStateToProps = (state) => {
  return {
    modal: state.modal,
    vehicleJourneys: state.vehicleJourneys,
    status: state.status,
    filters: state.filters
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalClose: () =>{
      dispatch(actions.closeModal())
    },
    onOpenShiftModal: () =>{
      dispatch(actions.openShiftModal())
    },
    onShiftVehicleJourney: (data) =>{
      dispatch(actions.shiftVehicleJourney(data))
    }
  }
}

const ShiftVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(ShiftVJComponent)

export default ShiftVehicleJourney
