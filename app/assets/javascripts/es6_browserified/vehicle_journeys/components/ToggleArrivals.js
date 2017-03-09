var React = require('react')
var PropTypes = require('react').PropTypes

const ToggleArrivals = ({filters, onToggleArrivals}) => {
  return (
    <div className='has_switch form-group inline'>
      <label htmlFor='toggleArrivals' className='control-label'>Afficher et éditer les horaires d'arrivée</label>
      <div className='form-group'>
        <div className='checkbox'>
          <label>
            <input
              onChange={onToggleArrivals}
              type='checkbox'
              checked={filters.toggleArrivals}
              >
            </input>
            <span className='switch-label'></span>
          </label>
        </div>
      </div>
    </div>
  )
}

ToggleArrivals.propTypes = {
  filters : PropTypes.object.isRequired,
  onToggleArrivals: PropTypes.func.isRequired
}

module.exports = ToggleArrivals
