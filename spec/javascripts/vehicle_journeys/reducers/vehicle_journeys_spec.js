var vjReducer = require('es6_browserified/vehicle_journeys/reducers/vehicleJourneys')

let state = []
let fakeFootnotes = [{
  id: 1,
  code: 1,
  label: "1"
},{
  id: 2,
  code: 2,
  label: "2"
}]

let fakeTimeTables = []
let fakeVJAS = [{
  delta : 627,
  arrival_time : {
    hour: '11',
    minute: '55'
  },
  departure_time : {
    hour: '22',
    minute: '22'
  },
  stop_area_object_id : "FR:92024:ZDE:420553:STIF"
}]

describe('vehicleJourneys reducer', () => {
  beforeEach(()=>{
    state = [
      {
        journey_pattern_id: 1,
        published_journey_name: "vj1",
        objectid: '11',
        deletable: false,
        selected: true,
        footnotes: fakeFootnotes,
        time_tables: fakeTimeTables,
        vehicle_journey_at_stops: fakeVJAS
      },
      {
        journey_pattern_id: 2,
        published_journey_name: "vj2",
        objectid: '22',
        selected: false,
        deletable: false,
        footnotes: fakeFootnotes,
        time_tables: fakeTimeTables,
        vehicle_journey_at_stops: fakeVJAS
      }
    ]
  })

  it('should return the initial state', () => {
    expect(
      vjReducer(undefined, {})
    ).toEqual([])
  })


  it('should handle ADD_VEHICLEJOURNEY', () => {
    let resultVJ = [{
      delta : 0,
      arrival_time : {
        hour: '00',
        minute: '00'
      },
      departure_time : {
        hour: '00',
        minute: '00'
      }
    }]
    let fakeData = {
      journey_pattern_id: {value : '1'},
      comment: {value: 'test'}
    }
    expect(
      vjReducer(state, {
        type: 'ADD_VEHICLEJOURNEY',
        data: fakeData
      })
    ).toEqual([{
      journey_pattern_id: 1,
      comment: 'test',
      objectid: '',
      footnotes: [],
      time_tables: [],
      vehicle_journey_at_stops: resultVJ,
      selected: false,
      deletable: false
    }, ...state])
  })

  it('should handle RECEIVE_VEHICLE_JOURNEYS', () => {
    expect(
      vjReducer(state, {
        type: 'RECEIVE_VEHICLE_JOURNEYS',
        json: state
      })
    ).toEqual(state)
  })

  it('should handle UPDATE_TIME', () => {
    const val = '33', subIndex = 0, index = 0, timeUnit = 'minute', isDeparture = true, isArrivalsToggled = true
    let newVJAS = [{
      delta: 638,
      arrival_time : {
        hour: '11',
        minute: '55'
      },
      departure_time : {
        hour: '22',
        minute: '33'
      },
      stop_area_object_id : "FR:92024:ZDE:420553:STIF"
    }]
    let newVJ = Object.assign({}, state[0], {vehicle_journey_at_stops: newVJAS})
    expect(
      vjReducer(state, {
        type: 'UPDATE_TIME',
        val,
        subIndex,
        index,
        timeUnit,
        isDeparture,
        isArrivalsToggled
      })
    ).toEqual([newVJ, state[1]])
  })

  it('should handle SELECT_VEHICLEJOURNEY', () => {
    const index = 1
    const newVJ = Object.assign({}, state[1], {selected: true})
    expect(
      vjReducer(state, {
        type: 'SELECT_VEHICLEJOURNEY',
        index
      })
    ).toEqual([state[0], newVJ])
  })

  it('should handle DELETE_VEHICLEJOURNEYS', () => {
    const newVJ = Object.assign({}, state[0], {deletable: true})
    expect(
      vjReducer(state, {
        type: 'DELETE_VEHICLEJOURNEYS'
      })
    ).toEqual([newVJ, state[1]])
  })

  it('should handle SHIFT_VEHICLEJOURNEY', () => {
    let newVJAS = [{
      delta: 627,
      arrival_time : {
        hour: '12',
        minute: '00'
      },
      departure_time : {
        hour: '22',
        minute: '27'
      },
      stop_area_object_id : "FR:92024:ZDE:420553:STIF"
    }]
    let fakeData = {
      objectid: {value : '11'},
      additional_time: {value: '5'}
    }
    let newVJ = Object.assign({}, state[0], {vehicle_journey_at_stops: newVJAS})
    expect(
      vjReducer(state, {
        type: 'SHIFT_VEHICLEJOURNEY',
        data: fakeData
      })
    ).toEqual([newVJ, state[1]])
  })

  it('should handle DUPLICATE_VEHICLEJOURNEY', () => {
    let newVJAS = [{
      delta: 627,
      arrival_time : {
        hour: '12',
        minute: '00'
      },
      departure_time : {
        hour: '22',
        minute: '27'
      },
      stop_area_object_id : "FR:92024:ZDE:420553:STIF"
    }]
    let fakeData = {
      duplicate_number: {value : 1},
      additional_time: {value: '5'}
    }
    let newVJ = Object.assign({}, state[0], {vehicle_journey_at_stops: newVJAS, selected: false})
    newVJ.comment = state[0].comment + '-0'
    delete newVJ['objectid']
    expect(
      vjReducer(state, {
        type: 'DUPLICATE_VEHICLEJOURNEY',
        data: fakeData
      })
    ).toEqual([state[0], newVJ, state[1]])
  })
})
