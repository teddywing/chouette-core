var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let SaveVehicleJourneys = ({ dispatch, journeyPatterns, page, status }) => {
  if(status.isFetching == true) {
    return false
  }
  if(status.fetchSuccess == true) {
    return (
      <form className='clearfix' onSubmit={e => {e.preventDefault()}}>
        <button
          className='btn btn-danger pull-right'
          type='submit'
          onClick={e => {
            e.preventDefault()
            actions.submitVehicleJourneys(dispatch, journeyPatterns)
          }}
          >
          Valider
        </button>
      </form>
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

SaveVehicleJourneys = connect(mapStateToProps)(SaveVehicleJourneys)

module.exports = SaveVehicleJourneys
