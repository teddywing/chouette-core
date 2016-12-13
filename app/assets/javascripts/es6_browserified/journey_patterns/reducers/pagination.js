const pagination = (state = 0, action) => {
  switch (action.type) {
    case 'GO_TO_PREVIOUS_PAGE':
      return state - 1
    case 'GO_TO_NEXT_PAGE':
      return state + 1
    default:
      return state
  }
}

module.exports = pagination
