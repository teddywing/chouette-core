var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

let Navigate = ({ dispatch, journeyPatterns, pagination, status }) => {
  let firstPage = 1
  let lastPage = Math.ceil(pagination.totalCount / window.journeyPatternsPerPage)

  let ItemLength = window.journeyPatternLength
  let firstItemOnPage = firstPage + (pagination.perPage * (pagination.page - firstPage))
  let lastItemOnPage = firstItemOnPage + (pagination.perPage - firstPage)

  if(status.isFetching == true) {
    return false
  }
  if(status.fetchSuccess == true) {
    return (
      <div className="pagination">
        Liste des missions {firstItemOnPage} à {(lastItemOnPage < ItemLength) ? lastItemOnPage : ItemLength} sur {ItemLength}
        <form className='page_links' onSubmit={e => {
            e.preventDefault()
          }}>
          <button
            onClick={e => {
              e.preventDefault()
              dispatch(actions.checkConfirmModal(e, actions.goToPreviousPage(dispatch, pagination), pagination.stateChanged, dispatch))
            }}
            type="submit"
            data-toggle=''
            data-target='#ConfirmModal'
            className={'previous_page' + (pagination.page == firstPage ? ' disabled' : '')}>
          </button>
          <button
            onClick={e => {
              e.preventDefault()
              dispatch(actions.checkConfirmModal(e, actions.goToNextPage(dispatch, pagination), pagination.stateChanged, dispatch))
            }}
            type="submit"
            data-toggle=''
            data-target='#ConfirmModal'
            className={'next_page' + (pagination.page == lastPage ? ' disabled' : '')}>
          </button>
        </form>
      </div>
    )
  } else {
    return false
  }
}

Navigate.propTypes = {
  journeyPatterns: PropTypes.array.isRequired,
  status: PropTypes.object.isRequired,
  pagination: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired
}

module.exports = Navigate
