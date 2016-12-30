var actions = require('../actions')
var connect = require('react-redux').connect
var CreateModal = require('../components/CreateModal')

const mapStateToProps = (state) => {
  return {
    modal: state.modal,
    journeyPatterns: state.journeyPatterns
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalClose: () =>{
      dispatch(actions.closeModal())
    },
    saveModal: (index, data) =>{
      dispatch(actions.saveModal(index, data))
    }
    // onOpenCreateModal: (index, journeyPattern) =>{
    //   dispatch(actions.openCreateModal(index, journeyPattern))
    // }
  }
}

const AddJourneyPattern = connect(mapStateToProps, mapDispatchToProps)(CreateModal)

module.exports = AddJourneyPattern
