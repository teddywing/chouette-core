var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')
var NavigateComponent = require('../components/Navigate')

const mapStateToProps = (state) => {
  return {
    metas: state.metas,
    timetable: state.timetable,
    status: state.status,
    pagination: state.pagination
  }
}


const Navigate = connect(mapStateToProps)(NavigateComponent)

module.exports = Navigate
