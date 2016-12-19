const actions = {
  receiveJourneyPatterns : (json) => ({
    type: "RECEIVE_JOURNEY_PATTERNS",
    json
  }),
  loadFirstPage: (dispatch) => ({
    type: 'LOAD_FIRST_PAGE',
    dispatch
  }),
  goToPreviousPage : (dispatch, currentPage) => ({
    type: 'GO_TO_PREVIOUS_PAGE',
    dispatch,
    currentPage,
    nextPage : false
  }),
  goToNextPage : (dispatch, currentPage) => ({
    type: 'GO_TO_NEXT_PAGE',
    dispatch,
    currentPage,
    nextPage : true
  }),
  updateCheckboxValue : (e, index) => {
    return {
      type : 'UPDATE_CHECKBOX_VALUE',
      id : e.currentTarget.id,
      index
    }
  },
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
          for (let stop_point of val.route_short_description.stop_points){
            stop_point.checked = false
            val.stop_area_short_descriptions.map((element) => {
              if(element.stop_area_short_description.id === stop_point.id){
                stop_point.checked = true
              }
            })
          }
          journeyPatterns.push({
            name: val.name,
            object_id: val.object_id,
            published_name: val.published_name,
            stop_points: val.route_short_description.stop_points
          })
        }
        dispatch(actions.receiveJourneyPatterns(journeyPatterns))
      })
  }
}

module.exports = actions
