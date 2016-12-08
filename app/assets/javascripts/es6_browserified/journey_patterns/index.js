var React = require('react')
var render = require('react-dom').render
var Provider = require('react-redux').Provider
var createStore = require('redux').createStore
var journeyPatternsApp = require('./reducers')
var App = require('./components/App')

// logger, DO NOT REMOVE
var applyMiddleware = require('redux').applyMiddleware
var createLogger = require('redux-logger')
var thunkMiddleware = require('redux-thunk').default
var promise = require('redux-promise')

const urlJSON = window.location.pathname + '.json'
var req = new Request(urlJSON, {
  credentials: 'same-origin'
});
const getInitialState = () => {
  console.log(urlJSON)
  let state = []
  fetch(req)
    .then(response => response.json())
    // .then(json => dispatch(receivePosts(reddit, json)))
    .then((json) => {
      console.log(json)
      for (let [i, val] of json.entries()){
        let stop_points = []
        for (let [i, stopArea] of val['stop_area_short_descriptions'].entries()){
          stop_points.push("id", false)
        }
        for (let [i, stopArea] of val['stop_area_short_descriptions'].entries()){
          stop_points["id"] = true
        }
        state.push({
          name: val.name,
          object_id: val.object_id,
          published_name: val.published_name
          // stop_points: stop_points
        })
      }
    })
  return state
}


var initialState = {journeyPatterns: getInitialState()}
const loggerMiddleware = createLogger()

let store = createStore(
  journeyPatternsApp,
  initialState,
  applyMiddleware(thunkMiddleware, promise, loggerMiddleware)
)

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('journey_patterns')
)
