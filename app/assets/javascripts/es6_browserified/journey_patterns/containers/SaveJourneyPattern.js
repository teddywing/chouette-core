var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let SaveJourneyPattern = ({ dispatch, journeyPatterns, page, status }) => {
  if(status.isFetching == true) {
    return false
  }
  if(status.fetchSuccess == true) {
    return (
      <div className='row mt-md'>
        <div className='col-lg-12 text-right'>
          <form className='jp_collection_submitr' onSubmit={e => {e.preventDefault()}}>
            <button
              className='btn btn-danger'
              type='submit'
              onClick={e => {
                e.preventDefault()
                actions.submitJourneyPattern(dispatch, journeyPatterns)
              }}
              >
              Enregistrer
            </button>
          </form>
        </div>
      </div>
    )
  } else {
    return false
  }
}

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns,
    page: state.pagination.page,
    status: state.status
  }
}

SaveJourneyPattern = connect(mapStateToProps)(SaveJourneyPattern)

module.exports = SaveJourneyPattern
