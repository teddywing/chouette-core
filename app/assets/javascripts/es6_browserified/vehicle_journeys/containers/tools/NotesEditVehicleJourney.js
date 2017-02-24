var connect = require('react-redux').connect
var NotesEditComponent = require('../../components/tools/NotesEditVehicleJourney')
var actions = require('../../actions')

const mapStateToProps = (state) => {
  return {
    modal: state.modal,
    vehicleJourneys: state.vehicleJourneys,
    status: state.status
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalClose: () =>{
      dispatch(actions.closeModal())
    },
    onOpenNotesEditModal: (vj) =>{
      dispatch(actions.openNotesEditModal(vj))
    },
    onToggleFootnoteModal: (footnote, isShown) => {
      dispatch(actions.toggleFootnoteModal(footnote, isShown))
    },
    onNotesEditVehicleJourney: (footnotes) =>{
      dispatch(actions.editVehicleJourneyNotes(footnotes))
    }
  }
}

const NotesEditVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(NotesEditComponent)

module.exports = NotesEditVehicleJourney
