var timetableReducer = require('es6_browserified/time_tables/reducers/timetable')

let state = {}

describe('timetable reducer', () => {
  beforeEach(() => {
    state = {
      current_month: [],
      current_periode_range: "",
      periode_range: [],
      time_table_periods: []
    }
  })

  it('should return the initial state', () => {
    expect(
      timetableReducer(undefined, {})
    ).toEqual({})
  })
})
