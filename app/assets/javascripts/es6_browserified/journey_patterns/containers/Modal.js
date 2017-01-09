var connect = require('react-redux').connect
var EditModal = require('../components/EditModal')
var CreateModal = require('../components/CreateModal')
var actions = require('../actions')

const mapStateToProps = (state) => {
  return {
    modal: state.modal,
    journeyPattern: state.journeyPattern
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalClose: () =>{
      dispatch(actions.closeModal())
    },
    saveModal: (index, data) =>{
      dispatch(actions.saveModal(index, data))
    },
    onDeleteJourneyPattern: (index) =>{
      dispatch(actions.deleteJourneyPattern(index))
    }
  }
}

const ModalContainer = connect(mapStateToProps, mapDispatchToProps)(EditModal, CreateModal)

module.exports = ModalContainer
