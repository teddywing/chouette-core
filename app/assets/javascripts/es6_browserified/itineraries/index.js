var React = require('react')
var render = require('react-dom').render
var Provider = require('react-redux').Provider
var createStore = require('redux').createStore
var reducers = require('./reducers')
var App = require('./components/App')
var addInput = require('./form_helper')

// logger, DO NOT REMOVE
// var applyMiddleware = require('redux').applyMiddleware
// var createLogger = require('redux-logger')
// var thunkMiddleware = require('redux-thunk').default
// var promise = require('redux-promise')

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
      user_objectid: value.user_objectid,
      index: index,
      edit: false,
      city_name: value.city_name,
      zip_code: value.zip_code,
      name: value.name,
      registration_number: value.registration_number,
      text: fancyText,
      for_boarding: value.for_boarding || "normal",
      for_alighting: value.for_alighting || "normal",
      longitude: value.longitude || 0,
      latitude: value.latitude || 0,
      olMap: {
        isOpened: false,
        json: {}
      }
    })
  }
  return state
}

var initialState = {stopPoints: getInitialState()}
// const loggerMiddleware = createLogger()
let store = createStore(
  reducers,
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
  for (let [i, stopPoint] of state.stopPoints.entries()){
    if (stopPoint.stoppoint_id == undefined){
      stopPoint.stoppoint_id = ""
    }
    addInput('id',stopPoint.stoppoint_id, i)
    addInput('stop_area_id',stopPoint.stoparea_id, i)
    addInput('position',i, i)
    addInput('for_boarding',stopPoint.for_boarding, i)
    addInput('for_alighting',stopPoint.for_alighting, i)
  }
})
