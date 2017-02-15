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
  arrival_time : "2000-01-01T00:00:00+01:00",
  departure_time : "2000-01-01T00:00:00+01:00",
  stop_area_object_id : "FR:92024:ZDE:420553:STIF"
}]

describe('vehicleJourneys reducer', () => {
  beforeEach(()=>{
    state = [
      {
        journey_pattern_id: 1,
        published_journey_name: "vj1",
        objectid: 11,
        deletable: false,
        footnotes: fakeFootnotes,
        time_tables: fakeTimeTables,
        vehicle_journey_at_stops: fakeVJAS
      },
      {
        journey_pattern_id: 2,
        published_journey_name: "vj2",
        objectid: 22,
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


  it('should handle RECEIVE_VEHICLE_JOURNEYS', () => {
    expect(
      vjReducer(state, {
        type: 'RECEIVE_VEHICLE_JOURNEYS',
        json: state
      })
    ).toEqual(state)
  })

  it('should handle UPDATE_TIME', () => {
    const val = 33, subIndex = 0, index = 0, timeUnit = 'minute', isDeparture = true, isArrivalsToggled = true
    let newVJAS = [{
      arrival_time : "2000-01-01T00:00:00+01:00",
      departure_time : "2000-01-01T00:33:00+01:00",
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

})
