var actions = require('../actions')
var connect = require('react-redux').connect
var ConfirmModal = require('../components/ConfirmModal')

const mapStateToProps = (state) => {
  return {
    modal: state.modal,
    journeyPatterns: state.journeyPatterns
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalAccept: (next, state) =>{
      dispatch(actions.fetchingApi())
      actions.submitJourneyPattern(dispatch, state, next)
    },
    onModalCancel: (next) =>{
      dispatch(actions.fetchingApi())
      dispatch(next)
    },
    onModalClose: () =>{
      dispatch(actions.closeModal())
    }
  }
}

const ConfirmModalContainer = connect(mapStateToProps, mapDispatchToProps)(ConfirmModal)

module.exports = ConfirmModalContainer
