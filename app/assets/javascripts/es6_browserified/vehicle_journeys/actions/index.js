const actions = {
  receiveVehicleJourneys : (json) => ({
    type: "RECEIVE_VEHICLE_JOURNEYS",
    json
  }),
  fetchingApi: () =>({
      type: 'FETCH_API'
  }),
  unavailableServer : () => ({
    type: 'UNAVAILABLE_SERVER'
  }),
  goToPreviousPage : (dispatch, pagination) => ({
    type: 'GO_TO_PREVIOUS_PAGE',
    dispatch,
    pagination,
    nextPage : false
  }),
  goToNextPage : (dispatch, pagination) => ({
    type: 'GO_TO_NEXT_PAGE',
    dispatch,
    pagination,
    nextPage : true
  }),
  checkConfirmModal : (event, callback, stateChanged, dispatch) => {
    if(stateChanged === true){
      return actions.openConfirmModal(callback)
    }else{
      dispatch(actions.fetchingApi())
      return callback
    }
  },
  toggleArrivals : () => ({
    type: 'TOGGLE_ARRIVALS',
  }),
  fetchVehicleJourneys : (dispatch, currentPage, nextPage) => {
    if(currentPage == undefined){
      currentPage = 1
    }
    let vehicleJourneys = []
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
    })
    let hasError = false
    fetch(req)
      .then(response => {
        if(response.status == 500) {
          hasError = true
        }
        return response.json()
      }).then((json) => {
        if(hasError == true) {
          dispatch(actions.unavailableServer())
        } else {
          let val
          for (val of json){
            var timeTables = []
            let tt
            for (tt of val.time_tables){
              timeTables.push({
                objectid: tt.objectid,
                comment: tt.comment
              })
            }
            vehicleJourneys.push({
              journey_pattern_id: val.journey_pattern_id,
              published_journey_name: val.published_journey_name,
              objectid: val.objectid,
              footnotes: val.footnotes,
              time_tables: timeTables,
              vehicle_journey_at_stops: val.vehicle_journey_at_stops,
              deletable: false
            })
          }
          // if(vehicleJourneys.length != window.vehicleJourneysPerPage){
          //   dispatch(actions.updateTotalCount(vehicleJourneys.length - window.vehicleJourneysPerPage))
          // }
          dispatch(actions.receiveVehicleJourneys(vehicleJourneys))
        }
      })
  }
}

module.exports = actions
