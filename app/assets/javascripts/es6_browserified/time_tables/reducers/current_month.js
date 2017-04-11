const currentMonth = (state = [], action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      return action.json.current_month
    default:
      return state
  }
}

module.exports = currentMonth
