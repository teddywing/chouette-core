var metasReducer = require('es6_browserified/time_tables/reducers/metas')

let state = {}

describe('metas reducer', () => {
  beforeEach(() => {
    let tag = {
      id: 0,
      name: 'test'
    }
    state = {
      comment: 'test',
      day_types: [true, true, true, true, true, true, true],
      color: 'blue',
      initial_tags: [tag],
      tags: [tag]
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
    ).toEqual(Object.assign({}, state, {day_types: arr, calendar: {name: 'Aucun'}}))
  })

  it('should handle UPDATE_COMMENT', () => {
    expect(
      metasReducer(state, {
        type: 'UPDATE_COMMENT',
        comment: 'title'
      })
    ).toEqual(Object.assign({}, state, {comment: 'title'}))
  })

  it('should handle UPDATE_COLOR', () => {
    expect(
      metasReducer(state, {
        type: 'UPDATE_COLOR',
        color: '#ffffff'
      })
    ).toEqual(Object.assign({}, state, {color: '#ffffff'}))
  })

  it('should handle UPDATE_SELECT_TAG', () => {
    expect(
      metasReducer(state, {
        type: 'UPDATE_SELECT_TAG',
        selectedItem:{
          id: 1,
          name: 'great'
        }
      })
    ).toEqual(Object.assign({}, state, {tags: [...state.tags, {id: 1, name:'great'}]}))
  })

  it('should handle UPDATE_UNSELECT_TAG', () => {
    expect(
      metasReducer(state, {
        type: 'UPDATE_UNSELECT_TAG',
        selectedItem:{
          id: 0,
          name: 'test'
        }
      })
    ).toEqual(Object.assign({}, state, {tags: []}))
  })
})
