var connect = require('react-redux').connect
var CreateModal = require('../components/CreateModal')
var actions = require('../actions')

const mapStateToProps = (state) => {
  return {
    modal: state.modal,
    vehicleJourneys: state.vehicleJourneys
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalClose: () =>{
      dispatch(actions.closeModal())
    }
  }
}

const ModalContainer = connect(mapStateToProps, mapDispatchToProps)(CreateModal)

module.exports = ModalContainer
