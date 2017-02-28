const stopPointsList = (state = [], action) => {
  switch (action.type) {
    case 'RECEIVE_JOURNEY_PATTERNS':
      if(action.json.length != 0){
        let sp = action.json[0].stop_points
        let spArray = []
        sp.map((s) => {
          spArray.push(s.name)
        })
        return [...spArray]
      }else{
        return state
      }
    default:
      return state
  }
}

module.exports = stopPointsList
