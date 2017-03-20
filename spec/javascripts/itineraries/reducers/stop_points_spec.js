var stopPointsReducer = require('es6_browserified/itineraries/reducers/stopPoints')

let state = []

let fakeData = {
  geometry: undefined,
  registration_number: 'rn_test',
  stoparea_id: 'sid_test',
  text: 't_test',
  user_objectid: 'uoid_test'
}

describe('stops reducer', () => {
  beforeEach(()=>{
    state = [
      {
        text: 'first',
        index: 0,
        edit: false,
        for_boarding: 'normal',
        for_alighting: 'normal',
        olMap: {
          isOpened: false,
          json: {}
        }
      },
      {
        text: 'second',
        index: 1,
        edit: false,
        for_boarding: 'normal',
        for_alighting: 'normal',
        olMap: {
          isOpened: false,
          json: {}
        }
      }
    ]
  })

  it('should return the initial state', () => {
    expect(
      stopPointsReducer(undefined, {})
    ).toEqual([])
  })

  it('should handle ADD_STOP', () => {
    expect(
      stopPointsReducer(state, {
        type: 'ADD_STOP'
      })
    ).toEqual(
      [
        {
          text: 'first',
          index: 0,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        },
        {
          text: 'second',
          index: 1,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        },
        {
          text: '',
          index: 2,
          edit: true,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })

  it('should handle MOVE_UP_STOP', () => {
    expect(
      stopPointsReducer(state, {
        type: 'MOVE_STOP_UP',
        index: 1
      })
    ).toEqual(
      [
        {
          text: 'second',
          index: 1,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        },
        {
          text: 'first',
          index: 0,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })

  it('should handle MOVE_DOWN_STOP', () => {
    expect(
      stopPointsReducer(state, {
        type: 'MOVE_STOP_DOWN',
        index: 0
      })
    ).toEqual(
      [
        {
          text: 'second',
          index: 1,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        },
        {
          text: 'first',
          index: 0,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })

  it('should handle DELETE_STOP', () => {
    expect(
      stopPointsReducer(state, {
        type: 'DELETE_STOP',
        index: 1
      })
    ).toEqual(
      [
        {
          text: 'first',
          index: 0,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })

  it('should handle UPDATE_INPUT_VALUE', () => {
    expect(
      stopPointsReducer(state, {
        type: 'UPDATE_INPUT_VALUE',
        index: 0,
        edit: false,
        text: {
          text: "new value",
          name: 'new',
          stoparea_id: 1,
          user_objectid: "1234",
          longitude: 123,
          latitude: 123,
          registration_number: '0',
          city_name: 'city',
          area_type: 'area',
          short_name: 'new'
        }
      })
    ).toEqual(
      [
        {
          text: 'new value',
          name: 'new',
          index: 0,
          edit: false,
          stoppoint_id: '',
          stoparea_id: 1,
          for_boarding: 'normal',
          for_alighting: 'normal',
          user_objectid: "1234",
          longitude: 123,
          latitude: 123,
          registration_number: '0',
          city_name: 'city',
          area_type: 'area',
          short_name: 'new',
          olMap: {
            isOpened: false,
            json: {}
          }
        },
        {
          text: 'second',
          index: 1,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })

  it('should handle UPDATE_SELECT_VALUE', () => {
    expect(
      stopPointsReducer(state, {
        type :'UPDATE_SELECT_VALUE',
        select_id: 'for_boarding',
        select_value: 'prohibited',
        index: 0
      })
    ).toEqual(
      [
        {
          text: 'first',
          index: 0,
          edit: false,
          for_boarding: 'prohibited',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        },
        {
          text: 'second',
          index: 1,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })

  it('should handle TOGGLE_MAP', () => {
    expect(
      stopPointsReducer(state, {
        type: 'TOGGLE_MAP',
        index: 0
      })
    ).toEqual(
      [
        {
          text: 'first',
          index: 0,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: true,
            json: {
              text: 'first',
              index: 0,
              edit: false,
              for_boarding: 'normal',
              for_alighting: 'normal',
              olMap: undefined
            }
          }
        },
        {
          text: 'second',
          index: 1,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })

  it('should handle TOGGLE_EDIT', () => {
    expect(
      stopPointsReducer(state, {
        type: 'TOGGLE_EDIT',
        index: 0
      })
    ).toEqual(
      [
        {
          text: 'first',
          index: 0,
          edit: true,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        },
        {
          text: 'second',
          index: 1,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })

  it('should handle SELECT_MARKER', () => {
    let openedMapState = [
      {
        text: 'first',
        index: 0,
        edit: false,
        for_boarding: 'normal',
        for_alighting: 'normal',
        olMap: {
          isOpened: true,
          json: {}
        }
      },
      {
        text: 'second',
        index: 1,
        edit: false,
        for_boarding: 'normal',
        for_alighting: 'normal',
        olMap: {
          isOpened: false,
          json: {}
        }
      }
    ]
    expect(
      stopPointsReducer(openedMapState, {
        type: 'SELECT_MARKER',
        index: 0,
        data: fakeData
      })
    ).toEqual(
      [
        {
          text: 'first',
          index: 0,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: true,
            json: fakeData
          }
        },
        {
          text: 'second',
          index: 1,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })

  it('should handle UNSELECT_MARKER', () => {
    let openedMapState = [
      {
        text: 'first',
        index: 0,
        edit: false,
        for_boarding: 'normal',
        for_alighting: 'normal',
        olMap: {
          isOpened: true,
          json: {}
        }
      },
      {
        text: 'second',
        index: 1,
        edit: false,
        for_boarding: 'normal',
        for_alighting: 'normal',
        olMap: {
          isOpened: false,
          json: {}
        }
      }
    ]

    expect(
      stopPointsReducer(openedMapState, {
        type: 'UNSELECT_MARKER',
        index: 0
      })
    ).toEqual(
      [
        {
          text: 'first',
          index: 0,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: true,
            json: {}
          }
        },
        {
          text: 'second',
          index: 1,
          edit: false,
          for_boarding: 'normal',
          for_alighting: 'normal',
          olMap: {
            isOpened: false,
            json: {}
          }
        }
      ]
    )
  })
})
