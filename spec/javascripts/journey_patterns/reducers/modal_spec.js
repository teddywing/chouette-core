var modalReducer = require('es6_browserified/journey_patterns/reducers/modal')

let state = {}

let fakeJourneyPattern = {
  name: 'jp_test 1',
  object_id: 'jp_test:JourneyPattern:1',
  published_name: 'jp_test publishedname 1',
  registration_number: 'jp_test registrationnumber 1',
  stop_points: [],
  deletable: false
}

const cb = function(){}

describe('modal reducer', () => {
  beforeEach(() => {
    state = {
      type: '',
      modalProps: {},
      confirmModal: {}
    }
  })

  it('should return the initial state', () => {
    expect(
      modalReducer(undefined, {})
    ).toEqual({})
  })

  it('should handle OPEN_CONFIRM_MODAL', () => {
    let newState = Object.assign({}, state, {
      type: 'confirm',
      confirmModal: {
        callback: cb
      }
    })
    expect(
      modalReducer(state, {
        type: 'OPEN_CONFIRM_MODAL',
        callback: cb
      })
    ).toEqual(newState)
  })

  it('should handle EDIT_JOURNEYPATTERN_MODAL', () => {
    let newState = Object.assign({}, state, {
      type: 'edit',
      modalProps: {
        index: 0,
        journeyPattern: fakeJourneyPattern
      },
      confirmModal: {}
    })
    expect(
      modalReducer(state, {
        type: 'EDIT_JOURNEYPATTERN_MODAL',
        index: 0,
        journeyPattern : fakeJourneyPattern
      })
    ).toEqual(newState)
  })

  it('should handle CREATE_JOURNEYPATTERN_MODAL', () => {
    expect(
      modalReducer(state, {
        type: 'CREATE_JOURNEYPATTERN_MODAL'
      })
    ).toEqual(Object.assign({}, state, { type: 'create' }))
  })

  it('should handle DELETE_JOURNEYPATTERN', () => {
    expect(
      modalReducer(state, {
        type: 'DELETE_JOURNEYPATTERN',
        index: 0
      })
    ).toEqual(state)
  })

  it('should handle SAVE_MODAL', () => {
    expect(
      modalReducer(state, {
        type: 'SAVE_MODAL',
        index: 0,
        data: {}
      })
    ).toEqual(state)
  })

  it('should handle CLOSE_MODAL', () => {
    expect(
      modalReducer(state, {
        type: 'CLOSE_MODAL'
      })
    ).toEqual(state)
  })
})
