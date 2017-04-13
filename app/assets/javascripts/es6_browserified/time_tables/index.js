var React = require('react')
var render = require('react-dom').render
var Provider = require('react-redux').Provider
var createStore = require('redux').createStore
var timeTablesApp = require('./reducers')
var App = require('./containers/App')

// logger, DO NOT REMOVE
var applyMiddleware = require('redux').applyMiddleware
var createLogger = require('redux-logger')
var thunkMiddleware = require('redux-thunk').default
var promise = require('redux-promise')

var initialState = {
  status: {
    policy: window.perms,
    fetchSuccess: true,
    isFetching: false
  },
  current_month: [],
  time_table_periods: [],
  periode_range: [],
  day_types: [],
  pagination: {
    page : 1,
    totalCount: window.journeyPatternLength,
    perPage: window.journeyPatternsPerPage,
    stateChanged: false
  },
  modal: {
    type: '',
    modalProps: {},
    confirmModal: {}
  }
}
const loggerMiddleware = createLogger()

let store = createStore(
  timeTablesApp,
  initialState,
  applyMiddleware(thunkMiddleware, promise, loggerMiddleware)
)

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('time_tables')
)
