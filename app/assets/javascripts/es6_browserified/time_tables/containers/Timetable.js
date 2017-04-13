var connect = require('react-redux').connect
var TimetableComponent = require('../components/Timetable')

const mapStateToProps = (state) => {
  return {
    current_month: state.current_month,
    time_table_periods: state.time_table_periods
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
  }
}

const Timetable = connect(mapStateToProps, mapDispatchToProps)(TimetableComponent)

module.exports = Timetable
