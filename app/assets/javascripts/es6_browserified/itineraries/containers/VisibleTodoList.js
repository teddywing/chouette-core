var actions = require('../actions')
var connect = require('react-redux').connect
var TodoList = require('../components/TodoList')

const mapStateToProps = (state) => {
  return {
    todos: state.todos
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onDeleteClick: (index) =>{
      dispatch(actions.deleteStop(index))
    },
    onMoveUpClick: (index) =>{
      dispatch(actions.moveStopUp(index))
    },
    onMoveDownClick: (index) =>{
      dispatch(actions.moveStopDown(index))
    },
    onChange: (index, text) =>{
      dispatch(actions.updateInputValue(index, text))
    },
    onSelectChange: (e, index) =>{
      dispatch(actions.updateSelectValue(e, index))
    }
  }
}

const VisibleTodoList = connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList)

module.exports = VisibleTodoList
