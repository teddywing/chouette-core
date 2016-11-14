import actions from '../actions'
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
    }
  }
}

const VisibleTodoList = connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList)

export default VisibleTodoList
