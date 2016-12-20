var React = require('react')
var connect = require('react-redux').connect
var actions = require('../actions')

let Navigate = ({ dispatch, journeyPatterns, page, length }) => {
  let firstPage = 1
  let lastPage = Math.round(length / 12)

  return (
    <form className='btn-group btn-group-sm' onSubmit={e => {
      e.preventDefault()
    }}>
    <button
      onClick={e => {
        e.preventDefault()
        dispatch(actions.goToPreviousPage(dispatch, page))
      }}
      type="submit"
      className={ (page == firstPage ? "hidden" : "") + " btn btn-default" }>
      <span className="fa fa-chevron-left"></span>
      </button>
      <button
        onClick={e => {
          e.preventDefault()
          dispatch(actions.goToNextPage(dispatch, page))
        }}
        type="submit"
        className={ (page == lastPage ? "hidden" : "") + " btn btn-default" }>
        <span className="fa fa-chevron-right"></span>
      </button>
    </form>
  )
}

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns,
    page: state.pagination,
    length: state.totalCount
  }
}

Navigate = connect(mapStateToProps)(Navigate)

module.exports = Navigate
