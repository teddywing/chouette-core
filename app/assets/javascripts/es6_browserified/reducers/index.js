var combineReducers = require('redux').combineReducers
var todos = require('./todos')

const todoApp = combineReducers({
  todos
})

module.exports = todoApp
