var actions = require("../actions")

const vehicleJourney= (state = {}, action) => {
  switch (action.type) {
    case 'UPDATE_TIME':
      let vj, vjas, vjasArray
      vjasArray = state.vehicle_journey_at_stops.map((vjas, i) =>{
        if(i == action.subIndex){
          if (action.isDeparture){
            return Object.assign({}, state.vehicle_journey_at_stops[action.subIndex],  {departure_time: moment(state.vehicle_journey_at_stops[action.subIndex].departure_time).set(action.timeUnit, action.val).format()})
          }else{
            return Object.assign({}, state.vehicle_journey_at_stops[action.subIndex],  {arrival_time: moment(state.vehicle_journey_at_stops[action.subIndex].arrival_time).set(action.timeUnit, action.val).format()})
          }
        }else{
          return vjas
        }
      })
      return Object.assign({}, state, {vehicle_journey_at_stops: vjasArray})
    default:
      return state
  }
}

const vehicleJourneys = (state = [], action) => {
  switch (action.type) {
    case 'RECEIVE_VEHICLE_JOURNEYS':
      return [...action.json]
    case 'RECEIVE_ERRORS':
      return [...action.json]
    case 'GO_TO_PREVIOUS_PAGE':
      if(action.pagination.page > 1){
        actions.fetchVehicleJourneys(action.dispatch, action.pagination.page, action.nextPage)
      }
      return state
    case 'GO_TO_NEXT_PAGE':
      if (action.pagination.totalCount - (action.pagination.page * action.pagination.perPage) > 0){
        actions.fetchVehicleJourneys(action.dispatch, action.pagination.page, action.nextPage)
      }
      return state
    case 'UPDATE_TIME':
      return state.map((vj, i) =>{
        if (i == action.index){
          return vehicleJourney(vj, action)
        } else {
          return vj
        }
      })
    default:
      return state
  }
}

module.exports = vehicleJourneys
