var actions = require('es6_browserified/time_tables/actions')

describe('actions', () => {
  it('should create an action to update dayTypes', () => {
    const expectedAction = {
      type: 'UPDATE_DAY_TYPES',
      index: 1
    }
    expect(actions.updateDayTypes(1)).toEqual(expectedAction)
  })

  it('should create an action to update comment', () => {
    const expectedAction = {
      type: 'UPDATE_COMMENT',
      comment: 'test'
    }
    expect(actions.updateComment('test')).toEqual(expectedAction)
  })

  it('should create an action to update color', () => {
    const expectedAction = {
      type: 'UPDATE_COLOR',
      color: '#ffffff'
    }
    expect(actions.updateColor('#ffffff')).toEqual(expectedAction)
  })

  it('should create an action to update selected tags', () => {
    let selectedItem = {
      id: 1,
      name: 'test'
    }
    const expectedAction = {
      type: 'UPDATE_SELECT_TAG',
      selectedItem: selectedItem
    }
    expect(actions.select2Tags(selectedItem)).toEqual(expectedAction)
  })

  it('should create an action to update unselected tags', () => {
    let selectedItem = {
      id: 1,
      name: 'test'
    }
    const expectedAction = {
      type: 'UPDATE_UNSELECT_TAG',
      selectedItem: selectedItem
    }
    expect(actions.unselect2Tags(selectedItem)).toEqual(expectedAction)
  })
})
