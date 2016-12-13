var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let Navigate = ({ dispatch, journeyPatterns, page }) => {
  return (
    <div className="clearfix" style={{marginBottom: 10}}>
      <form onSubmit={e => {
        e.preventDefault()
      }}>
        <button
          onClick={e => {
            e.preventDefault()
            dispatch(actions.goToNextPage())
          }}
          type="submit"
          className="btn btn-primary btn-xs pull-right">
          <span className="fa fa-plus"></span> Suivant
        </button>
        <button
          onClick={e => {
            e.preventDefault()
            dispatch(actions.goToPreviousPage())
          }}
          type="submit"
          className="btn btn-primary btn-xs pull-right">
          <span className="fa fa-plus"></span> Précédent
        </button>
      </form>
    </div>
  )
}
Navigate = connect()(Navigate)

module.exports = Navigate
