var React = require('react')
var connect = require('react-redux').connect
var addTodo = require('../actions').addStop

let AddTodo = ({ dispatch }) => {
  let input

  return (
    <div className="clearfix" style={{marginBottom: 10}}>
      <form onSubmit={e => {
        e.preventDefault()
        dispatch(addTodo())
      }}>
        <button type="submit" className="btn btn-primary btn-xs pull-right">
          <span className="fa fa-plus"></span> Ajouter un arrêt
        </button>
      </form>
    </div>
  )
}
AddTodo = connect()(AddTodo)

module.exports = AddTodo
