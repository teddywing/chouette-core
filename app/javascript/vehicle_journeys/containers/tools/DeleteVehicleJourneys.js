import actions from '../../actions'
import { connect } from 'react-redux'
import DeleteVJComponent from '../../components/tools/DeleteVehicleJourneys'

const mapStateToProps = (state) => {
  return {
    vehicleJourneys: state.vehicleJourneys,
    filters: state.filters
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onDeleteVehicleJourneys: () =>{
      dispatch(actions.deleteVehicleJourneys())
    },
  }
}

const DeleteVehicleJourneys = connect(mapStateToProps, mapDispatchToProps)(DeleteVJComponent)

export default DeleteVehicleJourneys
