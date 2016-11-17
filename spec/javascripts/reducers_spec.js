var reducer = require('es6_browserified/reducers/todos')
let state = []
describe('stops reducer', () => {
  beforeEach(()=>{
    state = [
      {
        text: 'first',
        index: 0,
        for_boarding: 'normal',
        for_alighting: 'normal'
      },
      {
        text: 'second',
        index: 1,
        for_boarding: 'normal',
        for_alighting: 'normal'
      }
    ]
  })

  it('should return the initial state', () => {
    expect(
      reducer(undefined, {})
    ).toEqual([])
  })

  it('should handle ADD_STOP', () => {
    expect(
      reducer(state, {
        type: 'ADD_STOP'
      })
    ).toEqual(
      [
        {
          text: 'first',
          index: 0,
          for_boarding: 'normal',
          for_alighting: 'normal'
        },
        {
          text: 'second',
          index: 1,
          for_boarding: 'normal',
          for_alighting: 'normal'
        },
        {
          text: '',
          index: 2,
          for_boarding: 'normal',
          for_alighting: 'normal'
        }
      ]
    )
  })

  it('should handle MOVE_UP_STOP', () => {
    expect(
      reducer(state, {
        type: 'MOVE_STOP_UP',
        index: 1
      })
    ).toEqual(
      [
        {
          text: 'second',
          index: 1,
          for_boarding: 'normal',
          for_alighting: 'normal'
        },
        {
          text: 'first',
          index: 0,
          for_boarding: 'normal',
          for_alighting: 'normal'
        }
      ]
    )
  })

  it('should handle MOVE_DOWN_STOP', () => {
    expect(
      reducer(state, {
        type: 'MOVE_STOP_DOWN',
        index: 0
      })
    ).toEqual(
      [
        {
          text: 'second',
          index: 1,
          for_boarding: 'normal',
          for_alighting: 'normal'
        },
        {
          text: 'first',
          index: 0,
          for_boarding: 'normal',
          for_alighting: 'normal'
        }
      ]
    )
  })

  it('should handle DELETE_STOP', () => {
    expect(
      reducer(state, {
        type: 'DELETE_STOP',
        index: 1
      })
    ).toEqual(
      [
        {
          text: 'first',
          index: 0,
          for_boarding: 'normal',
          for_alighting: 'normal'
        }
      ]
    )
  })

  //TODO unskip when es6 is properly functionnal
  xit('should handle UPDATE_INPUT_VALUE', () => {
    expect(
      reducer(state, {
        type: 'UPDATE_INPUT_VALUE',
        index: 0,
        text: {
          text: "new value",
          stoparea_id: 1
        }
      })
    ).toEqual(
      [
        {
          text: 'new value',
          index: 0,
          stoparea_id: 1,
          for_boarding: 'normal',
          for_alighting: 'normal'
        },
        {
          text: 'second',
          index: 1,
          for_boarding: 'normal',
          for_alighting: 'normal'
        }
      ]
    )
  })

  xit('should handle UPDATE_SELECT_VALUE', () => {
    expect(
      reducer(state, {
          type :'UPDATE_SELECT_VALUE',
          select_id: 'for_boarding',
          select_value: 'prohibited',
          index: 0
      })
    ).toEqual(
      [
        {
          text: 'new value',
          index: 0,
          stoparea_id: 1,
          for_boarding: 'prohibited',
          for_alighting: 'normal'
        },
        {
          text: 'second',
          index: 1,
          for_boarding: 'normal',
          for_alighting: 'normal'
        }
      ]
    )
  })
})
