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

  datas.map(function(v, i) {
    let fancyText = v.name.replace("&#39;", "\'")
    if(v.zip_code && v.city_name)
      fancyText += ", " + v.zip_code + " " + v.city_name.replace("&#39;", "\'")

    state.push({
      stoppoint_id: v.stoppoint_id,
      stoparea_id: v.stoparea_id,
      user_objectid: v.user_objectid,
      short_name: v.short_name.replace("&#39;", "\'"),
      area_type: v.area_type,
      index: i,
      edit: false,
      city_name: v.city_name.replace("&#39;", "\'"),
      zip_code: v.zip_code,
      name: v.name.replace("&#39;", "\'"),
      registration_number: v.registration_number,
      text: fancyText,
      for_boarding: v.for_boarding || "normal",
      for_alighting: v.for_alighting || "normal",
      longitude: v.longitude || 0,
      latitude: v.latitude || 0,
      olMap: {
        isOpened: false,
        json: {}
      }
    })
  })

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
  state.stopPoints.map((stopPoint, i) => {
    if (stopPoint.stoppoint_id == undefined){
      stopPoint.stoppoint_id = ""
    }
    addInput('id',stopPoint.stoppoint_id, i)
    addInput('stop_area_id',stopPoint.stoparea_id, i)
    addInput('position',i, i)
    addInput('for_boarding',stopPoint.for_boarding, i)
    addInput('for_alighting',stopPoint.for_alighting, i)
  })
})
