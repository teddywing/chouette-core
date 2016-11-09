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
var addInput = require('./form_helper').addInput

const getInitialState = () => {
  let state = []
  let datas = JSON.parse(decodeURIComponent(window.itinerary_stop))
  for (let [index, value] of datas.entries()){

    let fancyText = value.name
    if(value.zip_code && value.city_name)
      fancyText += ", " + value.zip_code + " " + value.city_name

    state.push({
      stoppoint_id: value.stoppoint_id,
      stoparea_id: value.stoparea_id,
      index: index,
      city_name: value.city_name,
      zip_code: value.zip_code,
      text: fancyText
    })
  }
  return state
}

var initialState = {todos: getInitialState()}
// const loggerMiddleware = createLogger()
let store = createStore(
  todoApp,
  initialState
  // applyMiddleware(thunkMiddleware, promise, loggerMiddleware)
)

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('stop_points')
)

document.querySelector('input[name=commit]').addEventListener('click', (event)=>{
  let state = store.getState()
  for (let [i, todo] of state.todos.entries()){
    if (todo.stoppoint_id == undefined){
      todo.stoppoint_id = ""
    }
    addInput('id',todo.stoppoint_id, i)
    addInput('stop_area_id',todo.stoparea_id, i)
  }
})
