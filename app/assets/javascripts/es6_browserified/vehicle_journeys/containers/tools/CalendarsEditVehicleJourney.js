var connect = require('react-redux').connect
var CalendarsEditComponent = require('../../components/tools/CalendarsEditVehicleJourney')
var actions = require('../../actions')

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
    onCalendarsEditVehicleJourney: (calendars) =>{
      dispatch(actions.editVehicleJourneyCalendars(calendars))
    },
    onSelect2Timetable: (e) =>{
      dispatch(actions.selectTTCalendarsModal(e.params.data))
    },
    onAddSelectedTimetable: () => {
      dispatch(actions.addSelectedTimetable())
    }
  }
}

const CalendarsEditVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(CalendarsEditComponent)

module.exports = CalendarsEditVehicleJourney
