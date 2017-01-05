var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let Navigate = ({ dispatch, journeyPatterns, page, length, onOpenConfirmModal }) => {
  let firstPage = 1
  let lastPage = Math.ceil(length / 12)

  return (
    <form className='btn-group btn-group-sm' onSubmit={e => {
      e.preventDefault()
    }}>
    <button
      onClick={e => {
        e.preventDefault()
        dispatch(actions.openConfirmModal(actions.goToPreviousPage(dispatch, page), actions.goToPreviousPage(dispatch, page)))
      }}
      type="submit"
      data-toggle='modal'
      data-target='#ConfirmModal'
      className={ (page == firstPage ? "hidden" : "") + " btn btn-default" }>
      <span className="fa fa-chevron-left"></span>
      </button>
      <button
        onClick={e => {
          e.preventDefault()
          dispatch(actions.openConfirmModal(actions.goToNextPage(dispatch, page), actions.goToNextPage(dispatch, page)))
        }}
        type="submit"
        data-toggle='modal'
        data-target='#ConfirmModal'
        className={ (page == lastPage ? "hidden" : "") + " btn btn-default" }>
        <span className="fa fa-chevron-right"></span>
      </button>
    </form>
  )
}
const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns,
    page: state.pagination,
    length: state.totalCount,
    confirmModalActions: state.modal.confirmActions
  }
}

Navigate = connect(mapStateToProps)(Navigate)

module.exports = Navigate
