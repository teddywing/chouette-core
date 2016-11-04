var React = require('react')
var PropTypes = require('react').PropTypes

const Todo = (props)  => (
  <div
    className="list-group-item"
  >
    <div>
      <em className="small">{props.id}</em>
    </div>
    <div className="text-right">
      <div className="btn-group btn-group-sm">
        <div className="btn btn-default">
          <span className="fa fa-times"></span>
        </div>
        <div
          className="btn btn-primary"
          onClick={props.onMoveUpClick}
        >
          <span className="fa fa-arrow-up"></span>
        </div>
        <div
          className="btn btn-primary"
          onClick={props.onMoveDownClick}
        >
          <span className="fa fa-arrow-down"></span>
        </div>
        <div
          className="btn btn-danger"
          onClick={props.onDeleteClick}
        >
          <span className="fa fa-trash"></span>
        </div>
      </div>
    </div>
  </div>
)

Todo.propTypes = {
  onDeleteClick: PropTypes.func.isRequired,
  onMoveUpClick: PropTypes.func.isRequired,
  onMoveDownClick: PropTypes.func.isRequired
}

module.exports = Todo
