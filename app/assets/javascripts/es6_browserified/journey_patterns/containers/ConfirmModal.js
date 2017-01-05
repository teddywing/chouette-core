var actions = require('../actions')
var connect = require('react-redux').connect
var ConfirmModal = require('../components/ConfirmModal')

const mapStateToProps = (state) => {
  return {
    modal: state.modal
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModal: (action) =>{
      dispatch(action)
    },
    onModalClose: () =>{
      dispatch(actions.closeModal())
    }
  }
}

const ConfirmModalContainer = connect(mapStateToProps, mapDispatchToProps)(ConfirmModal)

module.exports = ConfirmModalContainer
