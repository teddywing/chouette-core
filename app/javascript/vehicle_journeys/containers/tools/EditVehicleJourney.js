import actions from '../../actions'
import { connect } from 'react-redux'
import EditComponent from '../../components/tools/EditVehicleJourney'

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
    onOpenEditModal: (vj) =>{
      dispatch(actions.openEditModal(vj))
    },
    onEditVehicleJourney: (data, selectedCompany) =>{
      dispatch(actions.editVehicleJourney(data, selectedCompany))
    },
    onSelect2Company: (e) => {
      dispatch(actions.select2Company(e.params.data))
    },
    onUnselect2Company: () => {
      dispatch(actions.unselect2Company())
    },
  }
}

const EditVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(EditComponent)

export default EditVehicleJourney
