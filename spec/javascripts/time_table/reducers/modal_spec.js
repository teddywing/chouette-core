var modalReducer = require('es6_browserified/time_tables/reducers/modal')

let state = {}

describe('modal reducer', () => {
  beforeEach(() => {
    state = {
      confirmModal: {},
      modalProps: {
        active: false,
        begin: {
          day: '01',
          month: '01',
          year: String(new Date().getFullYear())
        },
        end: {
          day: '01',
          month: '01',
          year: String(new Date().getFullYear())
        },
        index: false,
        error: ''
      },
      type: ""
    }
  })

  it('should return the initial state', () => {
    expect(
      modalReducer(undefined, {})
    ).toEqual({})
  })

  it('should handle OPEN_CONFIRM_MODAL', () => {
    let callback = function(){}
    expect(
      modalReducer(state, {
        type: 'OPEN_CONFIRM_MODAL',
        callback
      })
    ).toEqual(Object.assign({}, state, {type: "confirm", confirmModal: { callback: callback }}))
  })

  it('should handle CLOSE_PERIOD_FORM', () => {
    let newModalProps = Object.assign({}, state.modalProps, {active: false})
    expect(
      modalReducer(state, {
        type: 'CLOSE_PERIOD_FORM'
      })
    ).toEqual(Object.assign({}, state, {modalProps: newModalProps}))
  })

  it('should handle OPEN_EDIT_PERIOD_FORM', () => {
    let period = {
      id : 1,
      period_end : "2017-03-05",
      period_start : "2017-02-23"
    }
    let period_start = period.period_start.split('-')
    let period_end = period.period_end.split('-')

    let index = 1

    let newModalProps = {
      active: true,
      begin: {
        day: period_start[2],
        month: period_start[1],
        year: period_start[0]
      },
      end: {
        day: period_end[2],
        month: period_end[1],
        year: period_end[0]
      },
      index: index,
      error: ''
    }
    expect(
      modalReducer(state, {
        type: 'OPEN_EDIT_PERIOD_FORM',
        period,
        index
      })
    ).toEqual(Object.assign({}, state, {modalProps: newModalProps}))
  })

  it('should handle OPEN_ADD_PERIOD_FORM', () => {
    let emptyDate = {
      day: '01',
      month: '01',
      year: String(new Date().getFullYear())
    }
    let newModalProps = Object.assign({}, state.modalProps, {
      active: true,
      begin: emptyDate,
      end: emptyDate,
      index: false,
      error: ""
    })

    expect(
      modalReducer(state, {
        type: 'OPEN_ADD_PERIOD_FORM'
      })
    ).toEqual(Object.assign({}, state, {modalProps: newModalProps}))
  })

  it('should handle UPDATE_PERIOD_FORM', () => {
    let val = "11"
    let group = "begin"
    let selectType = "day"

    let newModalProps = {
      active: false,
      begin: {
        day: val,
        month: '01',
        year: String(new Date().getFullYear())
      },
      end: {
        day: '01',
        month: '01',
        year: String(new Date().getFullYear())
      },
      index: false,
      error: ''
    }

    expect(
      modalReducer(state, {
        type: 'UPDATE_PERIOD_FORM',
        val,
        group,
        selectType
      })
    ).toEqual(Object.assign({}, state, {modalProps: newModalProps}))
  })

  it('should handle VALIDATE_PERIOD_FORM', () => {
    // if period_end <= period_start, throw error
    // if newperiod is on another one, throw error

    let modProps = {
      active: false,
      begin: {
        day: '13',
        month: '01',
        year: String(new Date().getFullYear())
      },
      end: {
        day: '01',
        month: '01',
        year: String(new Date().getFullYear())
      },
      index: false,
      error: ''
    }
    let newModalProps = {
      active: false,
      begin: {
        day: '01',
        month: '01',
        year: String(new Date().getFullYear())
      },
      end: {
        day: '01',
        month: '01',
        year: String(new Date().getFullYear())
      },
      index: false,
      error: 'La date de départ doit être antérieure à la date de fin'
    }

    let ttperiods = []

    expect(
      modalReducer(state, {
        type: 'VALIDATE_PERIOD_FORM',
        modalProps : modProps,
        timeTablePeriods: ttperiods
      })
    ).toEqual(Object.assign({}, state, {modalProps: newModalProps}))
  })
})
