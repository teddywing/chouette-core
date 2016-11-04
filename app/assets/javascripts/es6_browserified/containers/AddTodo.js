var React = require('react')
var connect = require('react-redux').connect
var addTodo = require('../actions').addStop

let AddTodo = ({ dispatch }) => {
  let input

  return (
    <div>
      <form onSubmit={e => {
        e.preventDefault()
        dispatch(addTodo())
      }}>
        <button type="submit">
          Add Todo
        </button>
      </form>
    </div>
  )
}
AddTodo = connect()(AddTodo)

module.exports = AddTodo
