var connect = require('react-redux').connect
var TimetableComponent = require('../components/Timetable')
var actions = require('../actions')

const mapStateToProps = (state) => {
  return {
    metas: state.metas,
    timetable: state.timetable,
    status: state.status
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onDeletePeriod: (index, dayTypes) =>{
      dispatch(actions.deletePeriod(index, dayTypes))
    },
    onExcludeDateFromPeriod: (index, day, dayTypes) => {
      dispatch(actions.excludeDateFromPeriod(index, day, dayTypes))
    },
    onIncludeDateInPeriod: (index, day, dayTypes) => {
      dispatch(actions.includeDateInPeriod(index, day, dayTypes))
    },
    onOpenEditPeriodForm: (period) => {
      dispatch(actions.openEditPeriodForm(period))
    }
  }
}

const Timetable = connect(mapStateToProps, mapDispatchToProps)(TimetableComponent)

module.exports = Timetable
