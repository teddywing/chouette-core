var jpReducer = require('es6_browserified/journey_patterns/reducers/journeyPatterns')
let state = []
let fakeStopPoints = [{
  area_type : "lda",
  checked : false,
  id : 45289,
  name : "Clichy Levallois",
  object_id : "FR:92044:LDA:72073:STIF",
  position : 0,
},{
  area_type : "lda",
  checked : false,
  id : 40534,
  name : "Thomas Lemaître",
  object_id : "FR:92050:LDA:70915:STIF",
  position : 1,
}]
let stopPoints = [{
  area_type : 'zdep',
  city_name : 'Plaisir',
  for_alighting : 'normal',
  for_boarding : 'normal',
  id : 14892,
  name : 'test1',
  object_id : 'test:StopPoint:1',
  position : 0,
  zip_code : '78490'
},{
  area_type : 'zdep',
  city_name : 'Plaisir',
  for_alighting : 'normal',
  for_boarding : 'normal',
  id : 14893,
  name : 'test2',
  object_id : 'test:StopPoint:2',
  position : 1,
  zip_code : '78490'
}]

describe('journeyPatterns reducer', () => {
  beforeEach(()=>{
    state = [
      {
        deletable: false,
        name: 'm1',
        object_id : 'o1',
        published_name: 'M1',
        registration_number: '',
        stop_points: fakeStopPoints
      },
      {
        deletable: false,
        name: 'm2',
        object_id : 'o2',
        published_name: 'M2',
        registration_number: '',
        stop_points: fakeStopPoints
      }
    ]
  })

  it('should return the initial state', () => {
    expect(
      jpReducer(undefined, {})
    ).toEqual([])
  })

  it('should handle ADD_JOURNEYPATTERN', () => {
    let fakeData = {
      name: {value : 'm3'},
      published_name: {value: 'M3'},
      registration_number: {value: ''}
    }
    let stopPoints = stopPoints
    expect(
      jpReducer(state, {
        type: 'ADD_JOURNEYPATTERN',
        data: fakeData
      })
    ).toEqual([{
      name : 'm3',
      published_name: 'M3',
      registration_number: '',
      deletable: false,
      stop_points: stopPoints
    }, ...state])
  })

  it('should handle UPDATE_CHECKBOX_VALUE', () => {
    let newFirstStopPoint = Object.assign({}, fakeStopPoints[0], {checked: !fakeStopPoints[0].checked} )
    let newStopPoints = [newFirstStopPoint, fakeStopPoints[1]]
    let newState = Object.assign({}, state[0], {stop_points: newStopPoints})
    expect(
      jpReducer(state, {
        type: 'UPDATE_CHECKBOX_VALUE',
        id: 45289,
        index: 0
      })
    ).toEqual([newState, state[1]])
  })

  it('should handle DELETE_JOURNEYPATTERN', () => {
    expect(
      jpReducer(state, {
        type: 'DELETE_JOURNEYPATTERN',
        index: 1
      })
    ).toEqual([state[0], Object.assign({}, state[1], {deletable: true})])
  })
  it('should handle SAVE_MODAL', () => {
    let newState = Object.assign({}, state[0], {name: 'p1', published_name: 'P1', registration_number: 'PP11'})
    expect(
      jpReducer(state, {
        type: 'SAVE_MODAL',
        data: {
          name: {value: 'p1'},
          published_name: {value: 'P1'},
          registration_number: {value: 'PP11'}
        },
        index: 0
      })
    ).toEqual([newState, state[1]])
  })
})
