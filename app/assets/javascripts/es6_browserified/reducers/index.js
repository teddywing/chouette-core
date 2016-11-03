var  combineReducers  = require('redux').combineReducers
var todos = require('./todos')
var visibilityFilter = require('./visibilityFilter')

const todoApp = combineReducers({
  todos,
  visibilityFilter
})

module.exports = todoApp
