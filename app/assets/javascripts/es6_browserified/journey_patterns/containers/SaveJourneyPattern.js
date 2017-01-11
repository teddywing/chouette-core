var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let SaveJourneyPattern = ({ dispatch, journeyPatterns, page }) => {
  return (
    <form className='clearfix' onSubmit={e => {e.preventDefault()}}>
      <button
        className='btn btn-danger pull-right'
        type='submit'
        onClick={e => {
          e.preventDefault()
          actions.submitJourneyPattern(dispatch, journeyPatterns)
        }}
      >
        Valider
      </button>
    </form>
  )
}

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns,
    page: state.pagination.page
  }
}

SaveJourneyPattern = connect(mapStateToProps)(SaveJourneyPattern)

module.exports = SaveJourneyPattern
