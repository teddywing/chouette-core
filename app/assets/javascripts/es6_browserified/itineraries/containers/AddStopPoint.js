var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let AddStopPoint = ({ dispatch }) => {
  return (
    <div className="nested-linker">
      <form onSubmit={e => {
        e.preventDefault()
        dispatch(actions.closeMaps())
        dispatch(actions.addStop())
      }}>
        <button type="submit" className="btn btn-outline-primary">
          Ajouter un arrêt
        </button>
      </form>
    </div>
  )
}
AddStopPoint = connect()(AddStopPoint)

module.exports = AddStopPoint
