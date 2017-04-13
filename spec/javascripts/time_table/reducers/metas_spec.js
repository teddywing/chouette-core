var metasReducer = require('es6_browserified/time_tables/reducers/metas')

let state = {}

describe('status reducer', () => {
  beforeEach(() => {
    state = {
    comment: 'test',
    day_types: [true, true, true, true, true, true, true],
    tags: ['t1'],
    color: 'blue'
    }
  })

  it('should return the initial state', () => {
    expect(
      metasReducer(undefined, {})
    ).toEqual({})
  })

  it('should handle UPDATE_DAY_TYPES', () => {
    const arr = [false, true, true, true, true, true, true]
    expect(
      metasReducer(state, {
        type: 'UPDATE_DAY_TYPES',
        index: 0
      })
    ).toEqual(Object.assign({}, state, {day_types: arr}))
  })

})
