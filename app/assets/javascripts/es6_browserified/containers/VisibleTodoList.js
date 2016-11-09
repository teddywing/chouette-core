var connect = require('react-redux').connect
var toggleTodo = require('../actions').toggleTodo
var deleteStop = require('../actions').deleteStop
var moveStopUp = require('../actions').moveStopUp
var moveStopDown = require('../actions').moveStopDown
var handleChange = require('../actions').updateInputValue
var TodoList = require('../components/TodoList')

const mapStateToProps = (state) => {
  return {
    todos: state.todos
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onDeleteClick: (index) =>{
      dispatch(deleteStop(index))
    },
    onMoveUpClick: (index) =>{
      dispatch(moveStopUp(index))
    },
    onMoveDownClick: (index) =>{
      dispatch(moveStopDown(index))
    },
    onChange: (index, text) =>{
      dispatch(handleChange(index, text))
    }
  }
}

const VisibleTodoList = connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList)

module.exports = VisibleTodoList
