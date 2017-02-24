var modalReducer = require('es6_browserified/vehicle_journeys/reducers/modal')

let state = {}

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

  it('should handle CREATE_VEHICLEJOURNEY_MODAL', () => {
    expect(
      modalReducer(state, {
        type: 'CREATE_VEHICLEJOURNEY_MODAL'
      })
    ).toEqual(Object.assign({}, state, { type: 'create' }))
  })

  it('should handle CLOSE_MODAL', () => {
    expect(
      modalReducer(state, {
        type: 'CLOSE_MODAL'
      })
    ).toEqual(state)
  })

  it('should handle EDIT_NOTES_VEHICLEJOURNEY_MODAL', () => {
    let vehicleJourney = {}
    let modalPropsResult = {
      vehicleJourney: {}
    }
    expect(
      modalReducer(state, {
        type: 'EDIT_NOTES_VEHICLEJOURNEY_MODAL',
        vehicleJourney
      })
    ).toEqual(Object.assign({}, state, {type: 'notes_edit', modalProps: modalPropsResult}))
  })

  it('should handle TOGGLE_FOOTNOTE_MODAL', () => {
    state.modalProps = {vehicleJourney : {footnotes: [{}, {}]}}
    let footnote = {}
    let newState = {
      // for the sake of the test, no need to specify the type
      type: '',
      modalProps:{vehicleJourney: {footnotes: [{},{},{}]}},
      confirmModal: {}
    }
    expect(
      modalReducer(state, {
        type: 'TOGGLE_FOOTNOTE_MODAL',
        footnote,
        isShown: true
      })
    ).toEqual(newState)
  })
})
