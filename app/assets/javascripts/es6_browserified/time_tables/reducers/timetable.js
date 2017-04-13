const _ = require('lodash')

const timetable = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      return _.assign({}, state, {
        current_month: action.json.current_month,
        time_table_periods: action.json.time_table_periods,
        periode_range: action.json.periode_range
      })
    default:
      return state
  }
}

module.exports = timetable
