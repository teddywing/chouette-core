var React = require('react')
var PropTypes = require('react').PropTypes
var Todo = require('./Todo')

const TodoList = ({ todos, onDeleteClick, onMoveUpClick, onMoveDownClick }) => (
  <div className='list-group'>
    {todos.map((todo, index) =>
      <Todo
        key={todo.id}
        {...todo}
        onDeleteClick={() => onDeleteClick(index)}
        onMoveUpClick={() => onMoveUpClick(index)}
        onMoveDownClick={() => onMoveDownClick(index)}
      />
    )}
  </div>
)

TodoList.propTypes = {
  todos: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number.isRequired,
  }).isRequired).isRequired,
  onDeleteClick: PropTypes.func.isRequired,
  onMoveUpClick: PropTypes.func.isRequired,
  onMoveDownClick: PropTypes.func.isRequired
}

module.exports = TodoList
