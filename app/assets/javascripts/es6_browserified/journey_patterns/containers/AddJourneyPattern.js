var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let AddJourneyPattern = ({ dispatch }) => {
  return (
    <div className="clearfix" style={{marginBottom: 10}}>
      <form onSubmit={e => {
        e.preventDefault()
        dispatch(actions.addStop())
      }}>
        <button type="submit" className="btn btn-primary btn-xs pull-right">
          <span className="fa fa-plus"></span> Ajouter une mission
        </button>
      </form>
    </div>
  )
}
AddJourneyPattern = connect()(AddJourneyPattern)

module.exports = AddJourneyPattern
