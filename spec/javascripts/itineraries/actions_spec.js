var actions = require('es6_browserified/itineraries/actions')

describe('actions', () => {
  it('should create an action to add a stop', () => {
    const expectedAction = {
      type: 'ADD_STOP',
    }
    expect(actions.addStop()).toEqual(expectedAction)
  })
})
describe('actions', () => {
  it('should create an action to move up a stop', () => {
    const index = 1
    const expectedAction = {
      type: 'MOVE_STOP_UP',
      index
    }
    expect(actions.moveStopUp(index)).toEqual(expectedAction)
  })
})
describe('actions', () => {
  it('should create an action to move down a stop', () => {
    const index = 1
    const expectedAction = {
      type: 'MOVE_STOP_DOWN',
      index
    }
    expect(actions.moveStopDown(index)).toEqual(expectedAction)
  })
})
describe('actions', () => {
  it('should create an action to delete a stop', () => {
    const index = 1
    const expectedAction = {
      type: 'DELETE_STOP',
      index
    }
    expect(actions.deleteStop(index)).toEqual(expectedAction)
  })
})
describe('actions', () => {
  it('should create an action to update the value of a stop', () => {
    const text = 'updated text'
    const index = 1
    const expectedAction = {
      type: 'UPDATE_INPUT_VALUE',
      index,
      text
    }
    expect(actions.updateInputValue(index, text)).toEqual(expectedAction)
  })
})

describe('actions', () => {
  it('should create an action to update the up select of a stop', () => {
    const event = {
      currentTarget: {
        value: 'forbidden',
        id: 'up'
      }
    }
    const index = 1
    const expectedAction = {
      type :'UPDATE_SELECT_VALUE',
      select_id: 'up',
      select_value: 'forbidden',
      index
    }
    expect(actions.updateSelectValue(event, index)).toEqual(expectedAction)
  })
})
