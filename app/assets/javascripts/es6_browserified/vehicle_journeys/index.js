var React = require('react')
var render = require('react-dom').render
var Provider = require('react-redux').Provider
var createStore = require('redux').createStore
var vehicleJourneysApp = require('./reducers')
var App = require('./components/App')

// logger, DO NOT REMOVE
var applyMiddleware = require('redux').applyMiddleware
var createLogger = require('redux-logger')
var thunkMiddleware = require('redux-thunk').default
var promise = require('redux-promise')

var selectedJP = []

if (window.journeyPatternId)
  selectedJP.push(window.journeyPatternId)

var initialState = {
  filters: {
    selectedJourneyPatterns : selectedJP,
    policy: window.perms,
    toggleArrivals: false,
    query: {
      interval: {
        start:{
          hour: '00',
          minute: '00'
        },
        end:{
          hour: '23',
          minute: '59'
        }
      },
      journeyPattern: {
        published_name: ''
      },
      timetable: {
        comment: ''
      },
      withoutSchedule: false
    }

  },
  status: {
    fetchSuccess: true,
    isFetching: false
  },
  vehicleJourneys: [],
  pagination: {
    page : 1,
    totalCount: window.vehicleJourneysLength,
    perPage: window.vehicleJourneysPerPage,
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
  vehicleJourneysApp,
  initialState,
  applyMiddleware(thunkMiddleware, promise, loggerMiddleware)
)

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('vehicle_journeys_wip')
)
