var React = require('react')
var render = require('react-dom').render
var Provider = require('react-redux').Provider
var createStore = require('redux').createStore
// var applyMiddleware = require('redux').applyMiddleware
var todoApp = require('./reducers')
var App = require('./components/App')
// var createLogger = require('redux-logger').default
// var thunkMiddleware = require('redux-thunk').default
// var promise = require('redux-promise')

const getInitialState = () => {
  let state = []
  let datas = JSON.parse(decodeURIComponent(window.itinerary_stop))
  for (let [index, value] of datas.entries()){
    state.push({
      index: index,
      text: value.name,
      city_name: value.city_name,
      zip_code: value.zip_code
    })
  }
  console.log(state)
  return state
}

var initialState = {todos: getInitialState()}
// const loggerMiddleware = createLogger()
let store = createStore(
  todoApp,
  initialState
  // applyMiddleware(thunkMiddleware, promise, loggerMiddleware)
)

console.log(store.getState())

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('stop_points')
)
