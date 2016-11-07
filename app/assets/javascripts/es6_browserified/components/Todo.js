var React = require('react')
var PropTypes = require('react').PropTypes

const firstBlock = {display: 'inline-block', verticalAlign: 'middle', width: '75%'}
const secondBlock = {display: 'inline-block', verticalAlign: 'middle', width: '25%', textAlign: 'right'}

const Todo = (props)  => (
  <div className="list-group-item">
    <div style={firstBlock}>
      <em className="small">{props.id}</em>
    </div>
    <div style={secondBlock}>
      <div className="btn-group btn-group-sm">
        <div className="btn btn-default">
          <span className="fa fa-times"></span>
        </div>
        <div
          className={"btn btn-primary" + (props.first ? " disabled" : "")}
          onClick={props.onMoveUpClick}
        >
          <span className="fa fa-arrow-up"></span>
        </div>
        <div
          className={"btn btn-primary" + (props.last ? " disabled" : "")}
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
  onMoveDownClick: PropTypes.func.isRequired,
  first: PropTypes.bool,
  last: PropTypes.bool
}

module.exports = Todo
