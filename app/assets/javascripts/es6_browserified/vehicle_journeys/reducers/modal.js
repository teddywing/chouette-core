let vehicleJourneysModal, newModalProps
const modal = (state = {}, action) => {
  switch (action.type) {
    case 'OPEN_CONFIRM_MODAL':
      $('#ConfirmModal').modal('show')
      return Object.assign({}, state, {
        type: 'confirm',
        confirmModal: {
          callback: action.callback,
        }
      })
    case 'EDIT_NOTES_VEHICLEJOURNEY_MODAL':
      let vehicleJourneyModal = Object.assign({}, action.vehicleJourney)
      return {
        type: 'notes_edit',
        modalProps: {
          vehicleJourney: vehicleJourneyModal
        },
        confirmModal: {}
      }
    case 'TOGGLE_FOOTNOTE_MODAL':
      newModalProps = JSON.parse(JSON.stringify(state.modalProps))
      if (action.isShown){
        newModalProps.vehicleJourney.footnotes.push(action.footnote)
      }else{
        newModalProps.vehicleJourney.footnotes = newModalProps.vehicleJourney.footnotes.filter((f) => {return f.id != action.footnote.id })
      }
      return Object.assign({}, state, {modalProps: newModalProps})
    case 'EDIT_VEHICLEJOURNEY_MODAL':
      return {
        type: 'edit',
        modalProps: {
          vehicleJourney: action.vehicleJourney
        },
        confirmModal: {}
      }
    case 'EDIT_CALENDARS_VEHICLEJOURNEY_MODAL':
      vehicleJourneysModal = JSON.parse(JSON.stringify(action.vehicleJourneys))
      let uniqTimetables = []
      let timetable = {}
      vehicleJourneysModal.map((vj, i) => {
        vj.time_tables.map((tt, j) =>{
          if(!isInArray(tt, uniqTimetables)){
            uniqTimetables.push(tt)
          }
        })
      })
      return {
        type: 'calendars_edit',
        modalProps: {
          vehicleJourneys: vehicleJourneysModal,
          timetables: uniqTimetables
        },
        confirmModal: {}
      }
    case 'DELETE_CALENDAR_MODAL':
      newModalProps = JSON.parse(JSON.stringify(state.modalProps))
      let timetablesModal = state.modalProps.timetables.slice(0)
      timetablesModal.map((tt, i) =>{
        if(tt == action.timetable){
          timetablesModal.splice(i, 1)
        }
      })
      vehicleJourneysModal = state.modalProps.vehicleJourneys.slice(0)
      vehicleJourneysModal.map((vj) =>{
        vj.time_tables.map((tt, i) =>{
          if (tt == action.timetable){
            vj.time_tables.splice(i, 1)
          }
        })
      })
      newModalProps.vehicleJourneys = vehicleJourneysModal
      newModalProps.timetables = timetablesModal
      return Object.assign({}, state, {modalProps: newModalProps})
    case 'CREATE_VEHICLEJOURNEY_MODAL':
      return {
        type: 'create',
        modalProps: {},
        confirmModal: {}
      }
    case 'SELECT_JP_CREATE_MODAL':
      newModalProps = {selectedJPModal : action.selectedItem}
      return Object.assign({}, state, {modalProps: newModalProps})
    case 'SHIFT_VEHICLEJOURNEY_MODAL':
      return {
        type: 'shift',
        modalProps: {},
        confirmModal: {}
      }
    case 'DUPLICATE_VEHICLEJOURNEY_MODAL':
      return {
        type: 'duplicate',
        modalProps: {},
        confirmModal: {}
      }
    case 'CLOSE_MODAL':
      return {
        type: '',
        modalProps: {},
        confirmModal: {}
      }
    default:
      return state
  }
}

function isInArray(value, array) {
  return array.indexOf(value) > -1;
}

module.exports = modal
