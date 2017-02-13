var statusReducer = require('es6_browserified/vehicle_journeys/reducers/filters')

let state = {}

describe('filters reducer', () => {
  beforeEach(() => {
    state = {
      toggleArrivals: false,
    }
  })

  it('should return the initial state', () => {
    expect(
      statusReducer(undefined, {})
    ).toEqual({})
  })

  it('should handle TOGGLE_ARRIVALS', () => {
    expect(
      statusReducer(state, {
        type: 'TOGGLE_ARRIVALS'
      })
    ).toEqual(Object.assign({}, state, {toggleArrivals: true}))
  })

})
