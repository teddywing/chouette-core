var connect = require('react-redux').connect
var PeriodFormComponent = require('../components/PeriodForm')
var actions = require('../actions')

const mapStateToProps = (state) => {
  return {
    modal: state.modal,
    timetable: state.timetable
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onOpenAddPeriodForm: () => {
      dispatch(actions.openAddPeriodForm())
    },
    onClosePeriodForm: () => {
      dispatch(actions.closePeriodForm())
    }
  }
}

const PeriodForm = connect(mapStateToProps, mapDispatchToProps)(PeriodFormComponent)

module.exports = PeriodForm
