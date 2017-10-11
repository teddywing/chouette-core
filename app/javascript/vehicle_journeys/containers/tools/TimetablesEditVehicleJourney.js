import actions from '../../actions'
import { connect } from 'react-redux'
import TimetablesEditComponent from '../../components/tools/TimetablesEditVehicleJourney'

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
    onOpenCalendarsEditModal: (vehicleJourneys) =>{
      dispatch(actions.openCalendarsEditModal(vehicleJourneys))
    },
    onDeleteCalendarModal: (timetable) => {
      dispatch(actions.deleteCalendarModal(timetable))
    },
    onTimetablesEditVehicleJourney: (vehicleJourneys, timetables) =>{
      dispatch(actions.editVehicleJourneyTimetables(vehicleJourneys, timetables))
    },
    onSelect2Timetable: (e) =>{
      dispatch(actions.selectTTCalendarsModal(e.params.data))
      dispatch(actions.addSelectedTimetable())
    }
  }
}

const TimetablesEditVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(TimetablesEditComponent)

export default TimetablesEditVehicleJourney
