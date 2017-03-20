var connect = require('react-redux').connect
var EditComponent = require('../../components/tools/EditVehicleJourney')
var actions = require('../../actions')

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
    }
  }
}

const EditVehicleJourney = connect(mapStateToProps, mapDispatchToProps)(EditComponent)

module.exports = EditVehicleJourney
