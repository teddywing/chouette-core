var React = require('react')
var PropTypes = require('react').PropTypes

const Filters = ({filters, onToggleArrivals}) => {
  return (
    <div className='list-group'>
        <span> Afficher les horaires d'arrivée</span>
        <input
          onChange = {onToggleArrivals}
          type = 'checkbox'
          checked = {filters.toggleArrivals}
        ></input>
    </div>
  )
}

Filters.propTypes = {
  filters : PropTypes.object.isRequired,
  onToggleArrivals: PropTypes.func.isRequired
}

module.exports = Filters
