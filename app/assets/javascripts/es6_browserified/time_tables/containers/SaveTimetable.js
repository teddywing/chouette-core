var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')
var SaveTimetableComponent = require('../components/SaveTimetable')

const mapStateToProps = (state) => {
  return {
    timetable: state.timetable,
    metas: state.metas,
    status: state.status
  }
}

const SaveTimetable = connect(mapStateToProps)(SaveTimetableComponent)

module.exports = SaveTimetable
