import actions from '../../actions'
import { connect } from 'react-redux'
import CreateModal from '../../components/tools/CreateModal'

const mapStateToProps = (state) => {
  return {
    modal: state.modal,
    vehicleJourneys: state.vehicleJourneys,
    status: state.status,
    stopPointsList: state.stopPointsList,
    filters: state.filters
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalClose: () =>{
      dispatch(actions.closeModal())
    },
    onAddVehicleJourney: (data, selectedJourneyPattern, stopPointsList, selectedCompany) =>{
      dispatch(actions.addVehicleJourney(data, selectedJourneyPattern, stopPointsList, selectedCompany))
    },
    onOpenCreateModal: () =>{
      dispatch(actions.openCreateModal())
    },
    onSelect2JourneyPattern: (e) =>{
      dispatch(actions.selectJPCreateModal(e.params.data))
    },
    onSelect2Company: (e) => {
      dispatch(actions.select2Company(e.params.data))
    }
  }
}

const AddVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(CreateModal)

export default AddVehicleJourney
