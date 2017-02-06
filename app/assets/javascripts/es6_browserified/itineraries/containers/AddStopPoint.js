var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let AddStopPoint = ({ dispatch }) => {
  return (
    <div className="clearfix" style={{marginBottom: 10}}>
      <form onSubmit={e => {
        e.preventDefault()
        dispatch(actions.addStop())
      }}>
        <label>Séquence d'arrêts</label>
        <button type="submit" className="btn btn-primary btn-xs pull-right">
          <span className="fa fa-plus"></span> Ajouter un arrêt
        </button>
      </form>
    </div>
  )
}
AddStopPoint = connect()(AddStopPoint)

module.exports = AddStopPoint
