import React, { Component } from 'react'
import PropTypes from 'prop-types'
import actions from '../../actions'

export default class VehicleJourneyInfoButton extends Component {
  constructor(props) {
    super(props)
  }


  render() {
    return (
      <li className='st_action'>
        <button
          type='button'
          data-toggle='modal'
          data-target='#EditVehicleJourneyModal'
          onClick={() => this.props.onOpenEditModal(this.props.vehicleJourney)}
        >
          <span className='fa fa-info'></span>
        </button>
      </li>
    )
  }
}

VehicleJourneyInfoButton.propTypes = {
  onOpenEditModal: PropTypes.func.isRequired,
  vehicleJourney: PropTypes.object.isRequired,
}
