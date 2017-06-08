var actions = require('../actions')
var connect = require('react-redux').connect
var ConfirmModal = require('../components/ConfirmModal')

const mapStateToProps = (state) => {
  return {
    modal: state.modal,
    timetable: state.timetable,
    metas: state.metas
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onModalAccept: (next, timetable, metas) =>{
      dispatch(actions.fetchingApi())
      actions.submitTimetable(dispatch, timetable, metas, next)
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
