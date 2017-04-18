var connect = require('react-redux').connect
var TimetableComponent = require('../components/Timetable')

const mapStateToProps = (state) => {
  return {
    timetable: state.timetable,
    status: state.status
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
  }
}

const Timetable = connect(mapStateToProps, mapDispatchToProps)(TimetableComponent)

module.exports = Timetable
