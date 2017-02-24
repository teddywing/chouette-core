const stopPointsList = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_JOURNEY_PATTERNS':
      let sp = action.json[0].stop_points
      let spArray = []
      sp.map((s) => {
        spArray.push(s.name)
      })
      return [...spArray]
    default:
      return state
  }
}

module.exports = stopPointsList
