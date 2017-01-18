var stopPointsReducer = require('es6_browserified/itineraries/reducers/stopPoints')

let state = []

describe('stops reducer', () => {
  beforeEach(()=>{
    state = [
      {
        text: 'first',
        index: 0,
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
        text: {
          text: "new value",
          stoparea_id: 1,
          user_objectid: "1234"
        }
      })
    ).toEqual(
      [
        {
          text: 'new value',
          index: 0,
          stoppoint_id: '',
          stoparea_id: 1,
          for_boarding: 'normal',
          for_alighting: 'normal',
          user_objectid: "1234",
          olMap: {
            isOpened: false,
            json: {}
          }
        },
        {
          text: 'second',
          index: 1,
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
