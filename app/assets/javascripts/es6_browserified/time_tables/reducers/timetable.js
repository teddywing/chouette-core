const _ = require('lodash')
var actions = require('../actions')
let newState = {}

const timetable = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      let fetchedState = _.assign({}, state, {
        current_month: action.json.current_month,
        current_periode_range: action.json.current_periode_range,
        periode_range: action.json.periode_range,
        time_table_periods: action.json.time_table_periods
      })
      return _.assign({}, fetchedState, {current_month: actions.updateSynthesis(fetchedState, actions.strToArrayDayTypes(action.json.day_types))})
    case 'RECEIVE_MONTH':
      newState = _.assign({}, state, {
        current_month: action.json.days
      })
      return _.assign({}, newState, {current_month: actions.updateSynthesis(newState, actions.strToArrayDayTypes(action.json.day_types))})
    case 'GO_TO_PREVIOUS_PAGE':
    case 'GO_TO_NEXT_PAGE':
      let nextPage = action.nextPage ? 1 : -1
      let newPage = action.pagination.periode_range[action.pagination.periode_range.indexOf(action.pagination.currentPage) + nextPage]
      $('#ConfirmModal').modal('hide')
      actions.fetchTimeTables(action.dispatch, newPage)
      return _.assign({}, state, {current_periode_range: newPage})
    case 'CHANGE_PAGE':
      $('#ConfirmModal').modal('hide')
      actions.fetchTimeTables(action.dispatch, action.page)
      return _.assign({}, state, {current_periode_range: action.page})
    case 'DELETE_PERIOD':
      let ttperiods = state.time_table_periods.map((period, i) =>{
        if(i == action.index){
          period.deleted = true
        }
        return period
      })
      newState = _.assign({}, state, {time_table_periods : ttperiods})
      return _.assign({}, newState, {current_month: actions.updateSynthesis(newState, action.dayTypes)})
    case 'INCLUDE_DATE_IN_PERIOD':
      let newCMi = state.current_month.map((d, i) => {
        if(i == action.index){
          d.include_date = !d.include_date
        }
        return d
      })
      newState = _.assign({}, state, {current_month: newCMi})
      return _.assign({}, newState, {current_month: actions.updateSynthesis(newState, action.dayTypes)})
    case 'EXCLUDE_DATE_FROM_PERIOD':
      let newCMe = state.current_month.map((d, i) => {
        if(i == action.index){
          d.excluded_date = !d.excluded_date
        }
        return d
      })
      newState = _.assign({}, state, {current_month: newCMe})
      return _.assign({}, newState, {current_month: actions.updateSynthesis(newState, action.dayTypes)})
    case 'VALIDATE_PERIOD_FORM':
      let period_start = actions.formatDate(action.modalProps.begin)
      let period_end = actions.formatDate(action.modalProps.end)
      let newPeriods = JSON.parse(JSON.stringify(state.time_table_periods))
      if (action.modalProps.index !== false){
        newPeriods[action.modalProps.index].period_start = period_start
        newPeriods[action.modalProps.index].period_end = period_end
      }else{
        let newPeriod = {
          period_start: period_start,
          period_end: period_end
        }
        newPeriods.push(newPeriod)
      }
      return _.assign({}, state, {time_table_periods: newPeriods})

    default:
      return state
  }
}

module.exports = timetable
