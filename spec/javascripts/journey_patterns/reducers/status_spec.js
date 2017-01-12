var statusReducer = require('es6_browserified/journey_patterns/reducers/status')

let state = {}

describe('status reducer', () => {
  beforeEach(() => {
    state = {
      fetchSuccess: true,
      isFetching: false
    }
  })

  it('should return the initial state', () => {
    expect(
      statusReducer(undefined, {})
    ).toEqual({})
  })

  it('should handle UNAVAILABLE_SERVER', () => {
    expect(
      statusReducer(state, {
        type: 'UNAVAILABLE_SERVER'
      })
    ).toEqual(Object.assign({}, state, {fetchSuccess: false}))
  })

  it('should handle RECEIVE_JOURNEY_PATTERNS', () => {
    expect(
      statusReducer(state, {
        type: 'RECEIVE_JOURNEY_PATTERNS'
      })
    ).toEqual(Object.assign({}, state, {fetchSuccess: true}))
  })
})
