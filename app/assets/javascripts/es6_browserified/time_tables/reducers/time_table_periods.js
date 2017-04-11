const timeTablePeriods = (state = [], action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      return action.json.time_table_periods
    default:
      return state
  }
}

module.exports = timeTablePeriods
