var actions = require('es6_browserified/vehicle_journeys/actions')

const dispatch = function(){}
const currentPage = 1

describe('when cannot fetch api', () => {
  it('should create an action to toggle error', () => {
    const expectedAction = {
      type: 'UNAVAILABLE_SERVER',
    }
    expect(actions.unavailableServer()).toEqual(expectedAction)
  })
})
describe('when fetching api', () => {
  it('should create an action to fetch api', () => {
    const expectedAction = {
      type: 'FETCH_API',
    }
    expect(actions.fetchingApi()).toEqual(expectedAction)
  })
})
describe('when receiveJourneyPatterns is triggered', () => {
  it('should create an action to pass json to reducer', () => {
    const json = undefined
    const expectedAction = {
      type: 'RECEIVE_VEHICLE_JOURNEYS',
      json
    }
    expect(actions.receiveVehicleJourneys()).toEqual(expectedAction)
  })
})
describe('when clicking on add button', () => {
  it('should create an action to open a create modal', () => {
    const expectedAction = {
      type: 'CREATE_VEHICLEJOURNEY_MODAL',
    }
    expect(actions.openCreateModal()).toEqual(expectedAction)
  })
})
describe('when clicking on validate button inside create modal', () => {
  it('should create an action to create a new vehicle journey', () => {
    const data = {}
    const expectedAction = {
      type: 'ADD_VEHICLEJOURNEY',
      data
    }
    expect(actions.addVehicleJourney(data)).toEqual(expectedAction)
  })
})
describe('when previous navigation button is clicked', () => {
  it('should create an action to go to previous page', () => {
    const nextPage = false
    const pagination = {
      totalCount: 25,
      perPage: 12,
      page:1
    }
    const expectedAction = {
      type: 'GO_TO_PREVIOUS_PAGE',
      dispatch,
      pagination,
      nextPage
    }
    expect(actions.goToPreviousPage(dispatch, pagination)).toEqual(expectedAction)
  })
})
describe('when next navigation button is clicked', () => {
  it('should create an action to go to next page', () => {
    const nextPage = true
    const pagination = {
      totalCount: 25,
      perPage: 12,
      page:1
    }
    const expectedAction = {
      type: 'GO_TO_NEXT_PAGE',
      dispatch,
      pagination,
      nextPage
    }
    expect(actions.goToNextPage(dispatch, pagination)).toEqual(expectedAction)
  })
})
describe('when checking a vehicleJourney', () => {
  it('should create an action to select vj', () => {
    const index = 1
    const expectedAction = {
      type: 'SELECT_VEHICLEJOURNEY',
      index
    }
    expect(actions.selectVehicleJourney(index)).toEqual(expectedAction)
  })
})
describe('when clicking on delete button', () => {
  it('should create an action to delete vj', () => {
    const expectedAction = {
      type: 'DELETE_VEHICLEJOURNEYS',
    }
    expect(actions.deleteVehicleJourneys()).toEqual(expectedAction)
  })
})
describe('when toggling arrivals', () => {
  it('should create an action to toggleArrivals', () => {
    const expectedAction = {
      type: 'TOGGLE_ARRIVALS',
    }
    expect(actions.toggleArrivals()).toEqual(expectedAction)
  })
})
describe('when updating vjas time', () => {
  it('should create an action to update time', () => {
    const val = 33, subIndex = 0, index = 0, timeUnit = 'minute', isDeparture = true, isArrivalsToggled = true
    const expectedAction = {
      type: 'UPDATE_TIME',
      val,
      subIndex,
      index,
      timeUnit,
      isDeparture,
      isArrivalsToggled
    }
    expect(actions.updateTime(val, subIndex, index, timeUnit, isDeparture, isArrivalsToggled)).toEqual(expectedAction)
  })
})
describe('when clicking on validate button inside shifting modal', () => {
  it('should create an action to shift a vehiclejourney schedule', () => {
    const data = {}
    const expectedAction = {
      type: 'SHIFT_VEHICLEJOURNEY',
      data
    }
    expect(actions.shiftVehicleJourney(data)).toEqual(expectedAction)
  })
})
describe('when clicking on validate button inside editing modal', () => {
  it('should create an action to update a vehiclejourney', () => {
    const data = {}
    const expectedAction = {
      type: 'EDIT_VEHICLEJOURNEY',
      data
    }
    expect(actions.editVehicleJourney(data)).toEqual(expectedAction)
  })
})
describe('when clicking on validate button inside duplicating modal', () => {
  it('should create an action to duplicate a vehiclejourney schedule', () => {
    const data = {}
    const expectedAction = {
      type: 'DUPLICATE_VEHICLEJOURNEY',
      data
    }
    expect(actions.duplicateVehicleJourney(data)).toEqual(expectedAction)
  })
})
describe('when clicking on edit notes modal', () => {
  it('should create an action to open footnotes modal', () => {
    const vehicleJourney = {}
    const expectedAction = {
      type: 'EDIT_NOTES_VEHICLEJOURNEY_MODAL',
      vehicleJourney
    }
    expect(actions.openNotesEditModal(vehicleJourney)).toEqual(expectedAction)
  })
})
describe('when clicking on a footnote button inside footnote modal', () => {
  it('should create an action to toggle this footnote', () => {
    const footnote = {}, isShown = true
    const expectedAction = {
      type: 'TOGGLE_FOOTNOTE_MODAL',
      footnote,
      isShown
    }
    expect(actions.toggleFootnoteModal(footnote, isShown)).toEqual(expectedAction)
  })
})
describe('when clicking on validate button inside footnote modal', () => {
  it('should create an action to update vj footnotes', () => {
    const footnotes = []
    const expectedAction = {
      type: 'EDIT_VEHICLEJOURNEY_NOTES',
      footnotes
    }
    expect(actions.editVehicleJourneyNotes(footnotes)).toEqual(expectedAction)
  })
})
describe('when clicking on calendar button in toolbox', () => {
  it('should create an action to open calendar modal', () => {
    const vehicleJourneys = []
    const expectedAction = {
      type: 'EDIT_CALENDARS_VEHICLEJOURNEY_MODAL',
      vehicleJourneys
    }
    expect(actions.openCalendarsEditModal(vehicleJourneys)).toEqual(expectedAction)
  })
})
describe('when clicking on delete button next to a timetable inside modal', () => {
  it('should create an action to delete timetable from selected vehicle journeys', () => {
    const timetable = {}
    const expectedAction = {
      type: 'DELETE_CALENDAR_MODAL',
      timetable
    }
    expect(actions.deleteCalendarModal(timetable)).toEqual(expectedAction)
  })
})
describe('when clicking on validate button inside calendars modal', () => {
  it('should create an action to update vj calendars', () => {
    const vehicleJourneys = []
    const expectedAction = {
      type: 'EDIT_VEHICLEJOURNEYS_CALENDARS',
      vehicleJourneys
    }
    expect(actions.editVehicleJourneyCalendars(vehicleJourneys)).toEqual(expectedAction)
  })
})
