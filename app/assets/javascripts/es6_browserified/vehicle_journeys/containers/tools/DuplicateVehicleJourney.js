var actions = require('../../actions')
var connect = require('react-redux').connect
var DuplicateVJComponent = require('../../components/tools/DuplicateVehicleJourney')

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
    onOpenDuplicateModal: () =>{
      dispatch(actions.openDuplicateModal())
    },
    onDuplicateVehicleJourney: (addtionalTime, duplicateNumber, departureDelta) =>{
      dispatch(actions.duplicateVehicleJourney(addtionalTime, duplicateNumber, departureDelta))
    }
  }
}

const DuplicateVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(DuplicateVJComponent)

module.exports = DuplicateVehicleJourney
