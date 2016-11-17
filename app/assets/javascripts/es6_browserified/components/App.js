var React = require('react')
var AddTodo = require('../containers/Addtodo')
var VisibleTodoList = require('../containers/VisibleTodoList')

const App = () => (
  <div>
    <AddTodo />
    <VisibleTodoList />
  </div>
)

module.exports = App
