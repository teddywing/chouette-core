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
        let val
        for (val of json){
          let stop_points = []
          for (let stop_point of val.route_short_description.stop_points){
            stop_point.checked = false
            stop_points[stop_point.object_id] = stop_point
          }
          for (let stopArea of val.stop_area_short_descriptions){
            stop_points[stopArea.stop_area_short_description.object_id].checked = true
          }
          state.push({
            name: val.name,
            object_id: val.object_id,
            published_name: val.published_name,
            stop_points: stop_points
          })
        }
        dispatch(actions.receiveJourneyPatterns(state))
      })
  }
}


module.exports = actions
