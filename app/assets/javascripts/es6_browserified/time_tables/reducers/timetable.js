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
    default:
      return state
  }
}

module.exports = timetable
