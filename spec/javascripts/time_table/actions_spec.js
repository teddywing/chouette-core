var actions = require('es6_browserified/time_tables/actions')

describe('actions', () => {
  it('should create an action to update dayTypes', () => {
    const expectedAction = {
      type: 'UPDATE_DAY_TYPES',
      index: 1
    }
    expect(actions.updateDayTypes(1)).toEqual(expectedAction)
  })
})
