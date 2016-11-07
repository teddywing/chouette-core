var React = require('react')
var PropTypes = require('react').PropTypes
var Todo = require('./Todo')

const TodoList = ({ todos, onDeleteClick, onMoveUpClick, onMoveDownClick }) => (
  <div className='list-group'>
    {todos.map((todo, index) =>
      <Todo
        key={'item-' + index}
        {...todo}
        onDeleteClick={() => onDeleteClick(index)}
        onMoveUpClick={() => onMoveUpClick(index)}
        onMoveDownClick={() => onMoveDownClick(index)}
        first={ index === 0 }
        last={ index === (todos.length - 1) }
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
