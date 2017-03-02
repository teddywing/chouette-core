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

  it('should handle SELECT_JP_CREATE_MODAL', () => {
    let newModalProps = {selectedJPModal : {id: 1}}
    expect(
      modalReducer(state, {
        type: 'SELECT_JP_CREATE_MODAL',
        selectedItem: {id: 1}
      })
    ).toEqual(Object.assign({}, state, {modalProps: newModalProps}))
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

  it('should handle EDIT_CALENDARS_VEHICLEJOURNEY_MODAL', () => {
    let vehicleJourneys = []
    let modalPropsResult = {
      vehicleJourneys: [],
      timetables: []
    }
    expect(
      modalReducer(state, {
        type: 'EDIT_CALENDARS_VEHICLEJOURNEY_MODAL',
        vehicleJourneys
      })
    ).toEqual(Object.assign({}, state, {type: 'calendars_edit', modalProps: modalPropsResult}))
  })

  it('should handle DELETE_CALENDAR_MODAL', () => {
    // TODO spec more for vehiclejourneys
    let deletableTimetable = {'delete': 'delete'}
    let fakeTimetables = [{'test': 'test'}, {'test 2': 'test 2'}, deletableTimetable]
    let newTimeTables = [{'test': 'test'}, {'test 2': 'test 2'}]
    let fakeVehicleJourneys= [{time_tables: fakeTimetables}, {time_tables: fakeTimetables}]
    state.modalProps = {vehicleJourneys : fakeVehicleJourneys, timetables: fakeTimetables }
    let footnote = {}
    let newState = {
      // for the sake of the test, no need to specify the type
      type: '',
      modalProps:{vehicleJourneys: [{time_tables: newTimeTables},{time_tables: newTimeTables}], timetables: [{'test': 'test'},{'test 2': 'test 2'}]},
      confirmModal: {}
    }
    expect(
      modalReducer(state, {
        type: 'DELETE_CALENDAR_MODAL',
        timetable: deletableTimetable
      })
    ).toEqual(newState)
  })
})
