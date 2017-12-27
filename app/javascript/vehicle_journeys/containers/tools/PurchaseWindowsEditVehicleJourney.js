import actions from '../../actions'
import { connect } from 'react-redux'
import PurchaseWindowsEditVehicleJourneyComponent from '../../components/tools/PurchaseWindowsEditVehicleJourney'

const mapStateToProps = (state, ownProps) => {
  return {
    editMode: state.editMode,
    modal: state.modal,
    vehicleJourneys: state.vehicleJourneys,
    status: state.status,
    disabled: ownProps.disabled
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalClose: () =>{
      dispatch(actions.closeModal())
    },
    onOpenCalendarsEditModal: (vehicleJourneys) =>{
      dispatch(actions.openPurchaseWindowsEditModal(vehicleJourneys))
    },
    onDeleteCalendarModal: (timetable) => {
      dispatch(actions.deletePurchaseWindowsModal(timetable))
    },
    onTimetablesEditVehicleJourney: (vehicleJourneys, timetables) =>{
      dispatch(actions.editVehicleJourneyPurchaseWindows(vehicleJourneys, timetables))
    },
    onSelect2Timetable: (e) =>{
      dispatch(actions.selectPurchaseWindowsModal(e.params.data))
      dispatch(actions.addSelectedPurchaseWindow())
    }
  }
}

const PurchaseWindowsEditVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(PurchaseWindowsEditVehicleJourneyComponent)

export default PurchaseWindowsEditVehicleJourney
