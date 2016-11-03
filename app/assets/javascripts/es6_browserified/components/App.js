var React = require('react')
var Footer = require('./Footer')
var AddTodo = require('../containers/AddTodo')
var VisibleTodoList = require('../containers/VisibleTodoList')

const App = () => (
  <div>
    <AddTodo />
    <VisibleTodoList />
    <Footer />
  </div>
)

module.exports = App
