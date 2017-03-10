var actions = require('../../actions')
var connect = require('react-redux').connect
var CreateModal = require('../../components/tools/CreateModal')

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
    onAddVehicleJourney: (data, selectedJourneyPattern, stopPointsList) =>{
      dispatch(actions.addVehicleJourney(data, selectedJourneyPattern, stopPointsList))
    },
    onOpenCreateModal: () =>{
      dispatch(actions.openCreateModal())
    },
    onSelect2JourneyPattern: (e) =>{
      dispatch(actions.selectJPCreateModal(e.params.data))
    }
  }
}

const AddVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(CreateModal)

module.exports = AddVehicleJourney
