import actions from '../../actions'
import { connect } from 'react-redux'
import NotesEditComponent from '../../components/tools/NotesEditVehicleJourney'

const mapStateToProps = (state, ownProps) => {
  return {
    editMode: state.editMode,
    disabled: ownProps.disabled,
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

export default NotesEditVehicleJourney
