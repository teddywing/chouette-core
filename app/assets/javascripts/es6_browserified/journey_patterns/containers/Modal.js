var connect = require('react-redux').connect
var ModalComponent = require('../components/Modal')
var actions = require('../actions')

const mapStateToProps = (state) => {
  return {
    modal: state.modal
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalClose: () =>{
      dispatch(actions.closeModal())
    },
    onDeleteJourneyPattern: (index, journeyPattern) =>{
      dispatch(actions.deleteJourneyPattern(index, journeyPattern))
    },
    saveModal: (data) =>{
      dispatch(actions.saveModal(data))
    }
  }
}

const ModalContainer = connect(mapStateToProps, mapDispatchToProps)(ModalComponent)

module.exports = ModalContainer
