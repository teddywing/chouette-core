var actions = require("../actions")

const vehicleJourney= (state = {}, action) => {
  switch (action.type) {
    case 'SELECT_VEHICLEJOURNEY':
      return Object.assign({}, state, {selected: !state.selected})
    case 'ADD_VEHICLEJOURNEY':
      let pristineVjas = JSON.parse(JSON.stringify(state[0].vehicle_journey_at_stops))
      pristineVjas.map((vj) =>{
        vj.departure_time.hour = '00'
        vj.departure_time.minute = '00'
        vj.arrival_time.hour = '00'
        vj.arrival_time.minute = '00'
        vj.delta = 0
        delete vj['stop_area_object_id']
      })
      return {
        journey_pattern_id: parseInt(action.data.journey_pattern_id.value),
        comment: action.data.comment.value,
        objectid: '',
        footnotes: [],
        time_tables: [],
        vehicle_journey_at_stops: pristineVjas,
        selected: false,
        deletable: false
      }
    case 'SHIFT_VEHICLEJOURNEY':
      let shiftedArray, shiftedSchedule, shiftedVjas
      shiftedArray = state.vehicle_journey_at_stops.map((vjas, i) => {
        shiftedSchedule = {
          departure_time: {
            hour: vjas.departure_time.hour,
            minute: String(parseInt(vjas.departure_time.minute) + parseInt(action.data.additional_time.value))
          },
          arrival_time: {
            hour: vjas.arrival_time.hour,
            minute: String(parseInt(vjas.arrival_time.minute) + parseInt(action.data.additional_time.value))
          }
        }
        actions.checkSchedules(shiftedSchedule)
        shiftedVjas =  Object.assign({}, state.vehicle_journey_at_stops[i], shiftedSchedule)
        return Object.assign({}, state.vehicle_journey_at_stops[i], shiftedVjas)
      })
      return Object.assign({}, state, {vehicle_journey_at_stops: shiftedArray})
    case 'UPDATE_TIME':
      let vj, vjas, vjasArray, newSchedule
      vjasArray = state.vehicle_journey_at_stops.map((vjas, i) =>{
        if(i == action.subIndex){
          newSchedule = {
            departure_time: Object.assign({}, vjas.departure_time),
            arrival_time: Object.assign({}, vjas.arrival_time)
          }
          if (action.isDeparture){
            newSchedule.departure_time[action.timeUnit] = action.val
            if(!action.isArrivalsToggled)
              newSchedule.arrival_time[action.timeUnit] = action.val
            newSchedule = actions.getDelta(newSchedule)
            return Object.assign({}, state.vehicle_journey_at_stops[action.subIndex], newSchedule)
          }else{
            newSchedule.arrival_time[action.timeUnit] = action.val
            newSchedule = actions.getDelta(newSchedule)
            return Object.assign({}, state.vehicle_journey_at_stops[action.subIndex],  {arrival_time: newArr})
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
    case 'ADD_VEHICLEJOURNEY':
      return [
        vehicleJourney(state, action),
        ...state
      ]
    case 'SHIFT_VEHICLEJOURNEY':
      return state.map((vj, i) => {
        if (vj.selected && (actions.getSelected(state).length == 1)){
          return vehicleJourney(vj, action)
        }else{
          return vj
        }
      })
    case 'DELETE_VEHICLEJOURNEYS':
      return state.map((vj, i) =>{
        if (vj.selected){
          return Object.assign({}, vj, {deletable: true})
        } else {
          return vj
        }
      })
    case 'SELECT_VEHICLEJOURNEY':
      return state.map((vj, i) =>{
        if (i == action.index){
          return vehicleJourney(vj, action)
        } else {
          return vj
        }
      })
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
