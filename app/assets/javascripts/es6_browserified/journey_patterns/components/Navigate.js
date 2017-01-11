var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

let Navigate = ({ dispatch, journeyPatterns, pagination }) => {
  let firstPage = 1
  let lastPage = Math.ceil(pagination.totalCount / window.journeyPatternsPerPage)

  return (
    <form className='btn-group btn-group-sm' onSubmit={e => {
      e.preventDefault()
    }}>
    <button
      onClick={e => {
        e.preventDefault()
        dispatch(actions.checkConfirmModal(e, actions.goToPreviousPage(dispatch, pagination), pagination.stateChanged))
      }}
      type="submit"
      data-toggle=''
      data-target='#ConfirmModal'
      className={ (pagination.page == firstPage ? "hidden" : "") + " btn btn-default" }>
      <span className="fa fa-chevron-left"></span>
      </button>
      <button
        onClick={e => {
          e.preventDefault()
          dispatch(actions.checkConfirmModal(e, actions.goToNextPage(dispatch, pagination), pagination.stateChanged))
        }}
        type="submit"
        data-toggle=''
        data-target='#ConfirmModal'
        className={ (pagination.page == lastPage ? "hidden" : "") + " btn btn-default" }>
        <span className="fa fa-chevron-right"></span>
      </button>
    </form>
  )
}

Navigate.propTypes = {
  journeyPatterns: PropTypes.array.isRequired,
  pagination: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired
}

module.exports = Navigate
