const actions = {
  receiveJourneyPatterns : (json) => ({
    type: "RECEIVE_JOURNEY_PATTERNS",
    json
  }),
  loadFirstPage: (dispatch) => ({
    type: 'LOAD_FIRST_PAGE',
    dispatch
  }),
  goToPreviousPage : (dispatch, currentPage) => {
    return {
      type: 'GO_TO_PREVIOUS_PAGE',
      dispatch,
      currentPage,
      nextPage : false
    }
  },
  goToNextPage : (dispatch, currentPage) => ({
    type: 'GO_TO_NEXT_PAGE',
    dispatch,
    currentPage,
    nextPage : true
  }),
  fetchJourneyPatterns : (dispatch, currentPage, nextPage) => {
    if(currentPage == undefined){
      currentPage = 1
    }
    let journeyPatterns = []
    let page
    switch (nextPage) {
      case true:
        page = currentPage + 1
        break
      case false:
        if(currentPage > 1){
          page = currentPage - 1
        }
        break
      default:
        page = currentPage
        break
    }
    let str = ".json"
    if(page > 1){
      str = '.json?page=' + page.toString()
    }
    let urlJSON = window.location.pathname + str
    let req = new Request(urlJSON, {
      credentials: 'same-origin',
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
          journeyPatterns.push({
            name: val.name,
            object_id: val.object_id,
            published_name: val.published_name,
            stop_points: stop_points
          })
        }
        dispatch(actions.receiveJourneyPatterns(journeyPatterns))
      })
  }
}


module.exports = actions
