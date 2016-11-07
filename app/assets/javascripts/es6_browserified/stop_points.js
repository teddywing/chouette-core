var React = require('react')
var render = require('react-dom').render
var Provider = require('react-redux').Provider
var createStore = require('redux').createStore
var todoApp = require('./reducers')
var App = require('./components/App')

let store = createStore(todoApp)

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('stop_points')
)
