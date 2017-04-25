var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')
var _ = require('lodash')

let Navigate = ({ dispatch, metas, timetable, pagination, status, filters}) => {
  if(status.isFetching == true) {
    return false
  }
  if(status.fetchSuccess == true) {
    let pageIndex = pagination.periode_range.indexOf(pagination.currentPage)
    let firstPage = pageIndex == 0
    let lastPage = pageIndex == pagination.periode_range.length - 1
    return (
      <div className="pagination pull-right">
        <form className='form-inline' onSubmit={e => {e.preventDefault()}}>
          {/* date selector */}
          <div className="form-group">
            <div className="dropdown month_selector" style={{display: 'inline-block'}}>
              <div
                className='btn btn-default dropdown-toggle'
                id='date_selector'
                data-toggle='dropdown'
                aria-haspopup='true'
                aria-expanded='true'
              >
                {pagination.currentPage ? (actions.monthName(pagination.currentPage) + ' ' + new Date(pagination.currentPage).getFullYear()) : ''}
                <span className='caret'></span>
              </div>
              <ul
                className='dropdown-menu'
                aria-labelledby='date_selector'
                >
                {_.map(pagination.periode_range, (month, i) => (
                  <li key={i}>
                    <button
                      type='button'
                      value={month}
                      onClick={e => {
                        e.preventDefault()
                        dispatch(actions.checkConfirmModal(e, actions.changePage(dispatch, pagination, e.currentTarget.value), pagination.stateChanged, dispatch))
                      }}
                    >
                      {actions.monthName(month) + ' ' + new Date(month).getFullYear()}
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          </div>

          {/* prev/next */}
          <div className="form-group">
            <div className="page_links">
              <button
                onClick={e => {
                  e.preventDefault()
                  dispatch(actions.checkConfirmModal(e, actions.goToPreviousPage(dispatch, pagination), pagination.stateChanged, dispatch))
                }}
                type='button'
                data-target='#ConfirmModal'
                className={(firstPage ? 'disabled ' : '') + 'previous_page'}
                disabled={(firstPage ? 'disabled' : '')}
                ></button>
              <button
                onClick={e => {
                  e.preventDefault()
                  dispatch(actions.checkConfirmModal(e, actions.goToNextPage(dispatch, pagination), pagination.stateChanged, dispatch))
                }}
                type='button'
                data-target='#ConfirmModal'
                className={(lastPage ? 'disabled ' : '') + 'next_page'}
                disabled={(lastPage ? 'disabled' : '')}
                ></button>
            </div>
          </div>
        </form>
      </div>
    )
  } else {
    return false
  }
}

Navigate.propTypes = {
  status: PropTypes.object.isRequired,
  pagination: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired
}

module.exports = Navigate
