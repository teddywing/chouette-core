var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

let Navigate = ({ dispatch, vehicleJourneys, pagination, status }) => {
  let firstPage = 1
  let lastPage = Math.ceil(pagination.totalCount / pagination.perPage)
  let minVJ = (pagination.page - 1) * pagination.perPage + 1
  let maxVJ = Math.min((pagination.page * pagination.perPage), pagination.totalCount)
  if(status.isFetching == true) {
    return false
  }
  if(status.fetchSuccess == true) {
    return (
      <div class="vj_wrapper">
        <div class="page_info">
          <span class="search">Résultats : {minVJ} - {maxVJ} sur {pagination.totalCount}</span>
        </div>
        <form className='btn-group btn-group-sm' onSubmit={e => {
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
            className={ (pagination.page == firstPage ? "hidden" : "") + " btn btn-default" }>
            <span className="fa fa-chevron-left"></span>
          </button>
          <button
            onClick={e => {
              e.preventDefault()
              dispatch(actions.checkConfirmModal(e, actions.goToNextPage(dispatch, pagination), pagination.stateChanged, dispatch))
            }}
            type="submit"
            data-toggle=''
            data-target='#ConfirmModal'
            className={ (pagination.page == lastPage ? "hidden" : "") + " btn btn-default" }>
            <span className="fa fa-chevron-right"></span>
          </button>
        </form>
      </div>
    )
  } else {
    return false
  }
}

Navigate.propTypes = {
  vehicleJourneys: PropTypes.array.isRequired,
  status: PropTypes.object.isRequired,
  pagination: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired
}

module.exports = Navigate
