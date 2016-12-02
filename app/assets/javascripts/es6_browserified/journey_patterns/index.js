var React = require('react')
var render = require('react-dom').render
var Provider = require('react-redux').Provider
var createStore = require('redux').createStore
var journeyPatternsApp = require('./reducers')

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
  fetch(req)
    .then(response => response.json())
    // .then(json => dispatch(receivePosts(reddit, json)))
    .then(json => console.log(json))
  let state = []
  return state
}


var initialState = {journeyPatterns: getInitialState()}
const loggerMiddleware = createLogger()

let store = createStore(
  journeyPatternsApp,
  initialState,
  applyMiddleware(thunkMiddleware, promise, loggerMiddleware)
)
