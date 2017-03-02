var actions = require('../../actions')
var connect = require('react-redux').connect
var CreateModal = require('../../components/tools/CreateModal')

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
    onAddVehicleJourney: (data, selectedJourneyPattern) =>{
      dispatch(actions.addVehicleJourney(data, selectedJourneyPattern))
    },
    onOpenCreateModal: () =>{
      dispatch(actions.openCreateModal())
    },
    onSelectJPModal: (e) =>{
      dispatch(actions.selectJPCreateModal(e.params.data))
    }
  }
}

const AddVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(CreateModal)

module.exports = AddVehicleJourney
