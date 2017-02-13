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
describe('when toggling arrivals', () => {
  it('should create an action to toggleArrivals', () => {
    const expectedAction = {
      type: 'TOGGLE_ARRIVALS',
    }
    expect(actions.toggleArrivals()).toEqual(expectedAction)
  })
})
