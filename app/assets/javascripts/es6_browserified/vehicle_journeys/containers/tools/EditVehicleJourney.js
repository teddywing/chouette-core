var connect = require('react-redux').connect
var EditComponent = require('../../components/tools/EditVehicleJourney')
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
    onOpenEditModal: (vj) =>{
      dispatch(actions.openEditModal(vj))
    },
    onEditVehicleJourney: (data) =>{
      dispatch(actions.editVehicleJourney(data))
    }
  }
}

const EditVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(EditComponent)

module.exports = EditVehicleJourney
