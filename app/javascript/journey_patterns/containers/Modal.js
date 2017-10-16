import { connect } from 'react-redux'
import actions from '../actions'
import EditModal from '../components/EditModal'
import CreateModal from '../components/CreateModal'

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
    }
  }
}

const ModalContainer = connect(mapStateToProps, mapDispatchToProps)(EditModal, CreateModal)

export default ModalContainer
