var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

let Navigate = ({ dispatch, journeyPatterns, page, length, stateChanged }) => {
  let firstPage = 1
  let lastPage = Math.ceil(length / 12)

  return (
    <form className='btn-group btn-group-sm' onSubmit={e => {
      e.preventDefault()
    }}>
    <button
      onClick={e => {
        e.preventDefault()
        dispatch(actions.checkConfirmModal(e, actions.goToPreviousPage(dispatch, page), stateChanged))
      }}
      type="submit"
      data-toggle=''
      data-target='#ConfirmModal'
      className={ (page == firstPage ? "hidden" : "") + " btn btn-default" }>
      <span className="fa fa-chevron-left"></span>
      </button>
      <button
        onClick={e => {
          e.preventDefault()
          dispatch(actions.checkConfirmModal(e, actions.goToNextPage(dispatch, page), stateChanged))
        }}
        type="submit"
        data-toggle=''
        data-target='#ConfirmModal'
        className={ (page == lastPage ? "hidden" : "") + " btn btn-default" }>
        <span className="fa fa-chevron-right"></span>
      </button>
    </form>
  )
}

Navigate.propTypes = {
  page: PropTypes.number.isRequired,
  length: PropTypes.number.isRequired,
  stateChanged: PropTypes.bool.isRequired,
  journeyPatterns: PropTypes.array.isRequired,
  dispatch: PropTypes.func.isRequired
}

module.exports = Navigate
