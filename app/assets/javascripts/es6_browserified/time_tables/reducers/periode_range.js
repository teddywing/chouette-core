const periodeRange = (state = [], action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      return action.json.periode_range
    default:
      return state
  }
}

module.exports = periodeRange
