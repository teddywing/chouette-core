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
            dispatch(actions.goToNextPage(dispatch, page))
          }}
          type="submit"
          className="btn btn-primary btn-xs pull-right">
          <span className="fa fa-plus"></span> Suivant
        </button>
        <button
          onClick={e => {
            e.preventDefault()
            dispatch(actions.goToPreviousPage(dispatch, page))
          }}
          type="submit"
          className="btn btn-primary btn-xs pull-right">
          <span className="fa fa-plus"></span> Précédent
        </button>
      </form>
    </div>
  )
}

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns,
    page: state.pagination
  }
}

Navigate = connect(mapStateToProps)(Navigate)

module.exports = Navigate
