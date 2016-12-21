var connect = require('react-redux').connect
var ModalComponent = require('../components/Modal')

const mapStateToProps = (state) => {
  return {
    modal: state.modal
  }
}

const ModalContainer = connect(mapStateToProps)(ModalComponent)

module.exports = ModalContainer
