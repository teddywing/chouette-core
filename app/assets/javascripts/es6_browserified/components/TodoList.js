var React = require('react')
var PropTypes = require('react').PropTypes
var Todo = require('./Todo')

const TodoList = ({ todos, onDeleteClick, onMoveUpClick, onMoveDownClick, onChange }) => {
  return (
    <div className='list-group'>
      {todos.map((todo, index) =>
        <Todo
          key={'item-' + index}
          onDeleteClick={() => onDeleteClick(index)}
          onMoveUpClick={() => {
            onMoveUpClick(index)}
          }
          onMoveDownClick={() => onMoveDownClick(index)}
          onChange={ onChange }
          first={ index === 0 }
          last={ index === (todos.length - 1) }
          index={ index }
          value={ todo }
        />
      )}
    </div>
  )
}

TodoList.propTypes = {
  todos: PropTypes.array.isRequired,
  onDeleteClick: PropTypes.func.isRequired,
  onMoveUpClick: PropTypes.func.isRequired,
  onMoveDownClick: PropTypes.func.isRequired
}

module.exports = TodoList
