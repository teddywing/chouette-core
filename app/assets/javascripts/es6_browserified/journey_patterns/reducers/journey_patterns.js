const journeyPatterns = (state = [], action) => {
  switch (action.type) {
    case 'RECEIVE_JOURNEY_PATTERNS':
      return [...action.state]
    default:
      return state
  }
}

module.exports = journeyPatterns
