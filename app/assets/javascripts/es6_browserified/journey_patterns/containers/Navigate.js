var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')
var NavigateComponent = require('../components/Navigate')

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns,
    page: state.pagination.page,
    length: state.pagination.totalCount,
    stateChanged: state.pagination.stateChanged
  }
}


const Navigate = connect(mapStateToProps)(NavigateComponent)

module.exports = Navigate
