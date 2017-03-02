var actions = require("../actions")

const vehicleJourney= (state = {}, action) => {
  switch (action.type) {
    case 'SELECT_VEHICLEJOURNEY':
      return Object.assign({}, state, {selected: !state.selected})
    case 'CANCEL_SELECTION':
      return Object.assign({}, state, {selected: false})
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
      let journeyPattern = {
        objectid: action.data.journey_pattern_objectid.value
      }
      return {
        journey_pattern: journeyPattern,
        published_journey_name: action.data.published_journey_name.value,
        objectid: '',
        footnotes: [],
        time_tables: [],
        vehicle_journey_at_stops: pristineVjas,
        selected: false,
        deletable: false
      }
    case 'DUPLICATE_VEHICLEJOURNEY':
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
            newSchedule.departure_time[action.timeUnit] = actions.pad(action.val)
            if(!action.isArrivalsToggled)
              newSchedule.arrival_time[action.timeUnit] = actions.pad(action.val)
            newSchedule = actions.getDelta(newSchedule)
            return Object.assign({}, state.vehicle_journey_at_stops[action.subIndex], {arrival_time: newSchedule.arrival_time, departure_time: newSchedule.departure_time, delta: newSchedule.delta})
          }else{
            newSchedule.arrival_time[action.timeUnit] = actions.pad(action.val)
            newSchedule = actions.getDelta(newSchedule)
            return Object.assign({}, state.vehicle_journey_at_stops[action.subIndex],  {arrival_time: newSchedule.arrival_time, departure_time: newSchedule.departure_time, delta: newSchedule.delta})
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
    case 'EDIT_VEHICLEJOURNEY':
      return state.map((vj, i) => {
        if (vj.selected){
          return Object.assign({}, vj, {
            published_journey_name: action.data.published_journey_name.value,
            published_journey_identifier: action.data.published_journey_identifier.value,
          })
        }else{
          return vj
        }
      })
    case 'EDIT_VEHICLEJOURNEY_NOTES':
      return state.map((vj, i) => {
        if (vj.selected){
          return Object.assign({}, vj, {
            footnotes: action.footnotes
          })
        }else{
          return vj
        }
      })
    case 'EDIT_VEHICLEJOURNEYS_CALENDARS':
      return state.map((vj,i) =>{
        if(vj.selected){
          let updatedVJ = Object.assign({}, vj)
          action.vehicleJourneys.map((vjm, j) =>{
            if(vj.objectid == vjm.objectid){
              updatedVJ.time_tables =  vjm.time_tables
            }
          })
          return updatedVJ
        }else{
          return vj
        }
      })
    case 'SHIFT_VEHICLEJOURNEY':
      return state.map((vj, i) => {
        if (vj.selected){
          return vehicleJourney(vj, action)
        }else{
          return vj
        }
      })
    case 'DUPLICATE_VEHICLEJOURNEY':
      let dupeVj
      let dupes = []
      let selectedIndex
      state.map((vj, i) => {
        if(vj.selected){
          selectedIndex = i
          for (i = 0; i< action.data.duplicate_number.value; i++){
            action.data.additional_time.value *= (i + 1)
            dupeVj = vehicleJourney(vj, action)
            dupeVj.published_journey_name = dupeVj.published_journey_name + '-' + i
            dupeVj.selected = false
            delete dupeVj['objectid']
            dupes.push(dupeVj)
          }
        }
      })
      let concatArray = state.slice(0, selectedIndex + 1).concat(dupes)
      concatArray = concatArray.concat(state.slice(selectedIndex + 1))
      return concatArray
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
    case 'CANCEL_SELECTION':
      return state.map((vj) => {
        return vehicleJourney(vj, action)
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
