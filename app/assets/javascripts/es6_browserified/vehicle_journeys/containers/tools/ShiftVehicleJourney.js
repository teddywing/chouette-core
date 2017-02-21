var actions = require('../../actions')
var connect = require('react-redux').connect
var ShiftVJComponent = require('../../components/tools/ShiftVehicleJourney')

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
    onOpenShiftModal: () =>{
      dispatch(actions.openShiftModal())
    },
    onShiftVehicleJourney: (data) =>{
      dispatch(actions.shiftVehicleJourney(data))
    }
  }
}

const ShiftVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(ShiftVJComponent)

module.exports = ShiftVehicleJourney
