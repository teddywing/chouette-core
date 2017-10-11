import actions from '../../actions'
import { connect } from 'react-redux'
import EditComponent from '../../components/tools/EditVehicleJourney'

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
