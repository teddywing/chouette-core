import {toggleTodo, deleteStop, moveStopUp, moveStopDown, updateInputValue} from '../actions'
import { connect } from 'react-redux'
import TodoList from '../components/TodoList'

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
      dispatch(updateInputValue(index, text))
    }
  }
}

const VisibleTodoList = connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList)

export default VisibleTodoList
