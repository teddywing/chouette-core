var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')
var NavigateComponent = require('../components/Navigate')

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns,
    pagination: state.pagination
  }
}


const Navigate = connect(mapStateToProps)(NavigateComponent)

module.exports = Navigate
