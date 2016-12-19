var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let AddJourneyPattern = ({ dispatch }) => {
  return (
    <form onSubmit={e => {
      e.preventDefault()
    }}>
      <button type="submit" className="btn btn-primary btn-sm pull-right">
        <span className="fa fa-plus"></span> Ajouter une mission
      </button>
    </form>
  )
}
AddJourneyPattern = connect()(AddJourneyPattern)

module.exports = AddJourneyPattern
