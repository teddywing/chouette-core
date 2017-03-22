var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')
var SaveJourneyPatternComponent = require('../components/SaveJourneyPattern')

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns,
    page: state.pagination.page,
    status: state.status
  }
}

const SaveJourneyPattern = connect(mapStateToProps)(SaveJourneyPatternComponent)

module.exports = SaveJourneyPattern
