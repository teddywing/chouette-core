var reducer = require('es6_browserified/journey_patterns/reducers/pagination')
let state = {
  page : 2,
  totalCount : 25
}
let currentPage = 2
const dispatch = function(){}

describe('pagination reducer, given parameters allowing page change', () => {

  it('should return the initial state', () => {
    expect(
      reducer(undefined, {})
    ).toEqual({})
  })

  it('should handle GO_TO_NEXT_PAGE and change state', () => {
    expect(
      reducer(state, {
        type: 'GO_TO_NEXT_PAGE',
        dispatch,
        currentPage,
        nextPage : true
      })
    ).toEqual(Object.assign({}, state, {page : state.page + 1}))
  })

  it('should return GO_TO_PREVIOUS_PAGE and change state', () => {
    expect(
      reducer(state, {
        type: 'GO_TO_PREVIOUS_PAGE',
        dispatch,
        currentPage,
        nextPage : false
      })
    ).toEqual(Object.assign({}, state, {page : state.page - 1}))
  })
})


describe('pagination reducer, given parameters not allowing to go to previous page', () => {

  beforeEach(()=>{
    state.page = 1
    currentPage = 1
  })

  it('should return GO_TO_PREVIOUS_PAGE and not change state', () => {
    expect(
      reducer(state, {
        type: 'GO_TO_PREVIOUS_PAGE',
        dispatch,
        currentPage,
        nextPage : false
      })
    ).toEqual(state)
  })
})

describe('pagination reducer, given parameters not allowing to go to next page', () => {

  beforeEach(()=>{
    state.page = 3
    currentPage = 3
  })

  it('should return GO_TO_NEXT_PAGE and not change state', () => {
    expect(
      reducer(state, {
        type: 'GO_TO_NEXT_PAGE',
        dispatch,
        currentPage,
        nextPage : false
      })
    ).toEqual(state)
  })
})
