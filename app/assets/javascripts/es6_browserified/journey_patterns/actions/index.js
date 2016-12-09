const actions = {
  receiveJourneyPatterns : (state) => ({
    type: "RECEIVE_JOURNEY_PATTERNS",
    state
  }),

  fetchJourneyPatterns : (dispatch) => {
    let state = []
    let urlJSON = window.location.pathname + '.json'
    let req = new Request(urlJSON, {
      credentials: 'same-origin'
    });
    fetch(req)
      .then(response => response.json())
      .then((json) => {
        console.log(json)
        for (let [i, val] of json.entries()){
          let stop_points = []
          for (let [i, stopArea] of val['stop_area_short_descriptions'].entries()){
            stop_points.push("id", false)
          }
          for (let [i, stopArea] of val['stop_area_short_descriptions'].entries()){
            stop_points["id"] = true
          }
          state.push({
            name: val.name,
            object_id: val.object_id,
            published_name: val.published_name
            // stop_points: stop_points
          })
        }
        dispatch(actions.receiveJourneyPatterns(state))
      })
  }
}


module.exports = actions
