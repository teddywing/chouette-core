const actions = {
  receiveVehicleJourneys : (json) => ({
    type: "RECEIVE_VEHICLE_JOURNEYS",
    json
  }),
  receiveErrors : (json) => ({
    type: "RECEIVE_ERRORS",
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
  openCreateModal : () => ({
    type : 'CREATE_VEHICLEJOURNEY_MODAL'
  }),
  openShiftModal : () => ({
    type : 'SHIFT_VEHICLEJOURNEY_MODAL'
  }),
  selectVehicleJourney : (index) => ({
    type : 'SELECT_VEHICLEJOURNEY',
    index
  }),
  addVehicleJourney : (data) => ({
    type: 'ADD_VEHICLEJOURNEY',
    data
  }),
  shiftVehicleJourney : (data) => ({
    type: 'SHIFT_VEHICLEJOURNEY',
    data
  }),
  duplicateVehicleJourneys : (data) => ({
    type: 'DUPLICATE_VEHICLEJOURNEY'
  }),
  deleteVehicleJourneys : () => ({
    type: 'DELETE_VEHICLEJOURNEYS'
  }),
  openConfirmModal : (callback) => ({
    type : 'OPEN_CONFIRM_MODAL',
    callback
  }),
  closeModal : () => ({
    type : 'CLOSE_MODAL'
  }),
  resetValidation: (target) => {
    $(target).parent().removeClass('has-error').children('.help-block').remove()
  },
  validateFields : (fields) => {
    const test = []

    Object.keys(fields).map(function(key) {
      test.push(fields[key].validity.valid)
    })
    if(test.indexOf(false) >= 0) {
      // Form is invalid
      test.map(function(item, i) {
        if(item == false) {
          const k = Object.keys(fields)[i]
          $(fields[k]).parent().addClass('has-error').children('.help-block').remove()
          $(fields[k]).parent().append("<span class='small help-block'>" + fields[k].validationMessage + "</span>")
        }
      })
      return false
    } else {
      // Form is valid
      return true
    }
  },
  toggleArrivals : () => ({
    type: 'TOGGLE_ARRIVALS',
  }),
  updateTime : (val, subIndex, index, timeUnit, isDeparture, isArrivalsToggled) => ({
    type: 'UPDATE_TIME',
    val,
    subIndex,
    index,
    timeUnit,
    isDeparture,
    isArrivalsToggled
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
            let vjasWithDelta = val.vehicle_journey_at_stops.map((vjas, i) => {
              return actions.getDelta(vjas)
            })
            vehicleJourneys.push({
              journey_pattern_id: val.journey_pattern_id,
              published_journey_name: val.published_journey_name,
              objectid: val.objectid,
              footnotes: val.footnotes,
              time_tables: timeTables,
              vehicle_journey_at_stops: vjasWithDelta,
              deletable: false,
              selected: false
            })
          }
          // if(vehicleJourneys.length != window.vehicleJourneysPerPage){
          //   dispatch(actions.updateTotalCount(vehicleJourneys.length - window.vehicleJourneysPerPage))
          // }
          dispatch(actions.receiveVehicleJourneys(vehicleJourneys))
        }
      })
  },
  submitVehicleJourneys : (dispatch, state, next) => {
    dispatch(actions.fetchingApi())
    let urlJSON = window.location.pathname + "_collection.json"
    let req = new Request(urlJSON, {
      credentials: 'same-origin',
      method: 'PATCH',
      contentType: 'application/json; charset=utf-8',
      Accept: 'application/json',
      body: JSON.stringify(state),
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    })
    let hasError = false
    fetch(req)
      .then(response => {
        if(!response.ok) {
          hasError = true
        }
        return response.json()
      }).then((json) => {
        if(hasError == true) {
          dispatch(actions.receiveErrors(json))
        } else {
          if(next) {
            dispatch(next)
          } else {
            dispatch(actions.receiveVehicleJourneys(json))
          }
        }
      })
  },

  // VJAS HELPERS
  pad: (d) => {
    return (d < 10) ? '0' + d.toString() : d.toString();
  },
  getDelta: (vjas) => {
    let delta = 0
    if (vjas.departure_time.hour != '' && vjas.departure_time.minute != '' && vjas.arrival_time.hour != '' && vjas.departure_time.minute != ''){
      delta = (vjas.departure_time.hour - vjas.arrival_time.hour) * 60 + (vjas.departure_time.minute - vjas.arrival_time.minute)
    }
    vjas.delta = delta
    return vjas
  },
  checkSchedules: (schedule) => {
    if (parseInt(schedule.departure_time.minute) > 59){
      schedule.departure_time.minute = actions.pad(parseInt(schedule.departure_time.minute) - 60)
      schedule.departure_time.hour = actions.pad(parseInt(schedule.departure_time.hour) + 1)
    }
    if (parseInt(schedule.arrival_time.minute) > 59){
      schedule.arrival_time.minute = actions.pad(parseInt(schedule.arrival_time.minute) - 60)
      schedule.arrival_time.hour = actions.pad(parseInt(schedule.arrival_time.hour) + 1)
    }
    if (parseInt(schedule.departure_time.hour) > 23){
      schedule.departure_time.hour = actions.pad(parseInt(schedule.departure_time.hour) - 24)
    }
    if (parseInt(schedule.arrival_time.hour) > 23){
      schedule.arrival_time.hour = actions.pad(parseInt(schedule.arrival_time.hour) - 24)
    }
  }
}

module.exports = actions
