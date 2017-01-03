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
    onAddJourneyPattern: (index, data) =>{
      dispatch(actions.addJourneyPattern(index, data))
    },
    onOpenCreateModal: () =>{
      dispatch(actions.openCreateModal())
    }
  }
}

const AddJourneyPattern = connect(mapStateToProps, mapDispatchToProps)(CreateModal)

module.exports = AddJourneyPattern
