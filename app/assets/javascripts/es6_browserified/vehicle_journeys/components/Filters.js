var React = require('react')
var PropTypes = require('react').PropTypes

const Filters = ({filters, onFilters}) => {
  return (
    <span>Filters</span>
  )
}

Filters.propTypes = {
  filters : PropTypes.object.isRequired,
  onFilters: PropTypes.func.isRequired
}

module.exports = Filters
