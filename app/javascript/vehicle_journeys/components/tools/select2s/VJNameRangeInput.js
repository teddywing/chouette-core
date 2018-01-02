import _ from 'lodash'
import React, { PropTypes, Component } from 'react'
import actions from '../../../actions'


export default class BSelect4b extends Component {
  constructor(props) {
    super(props)
    this.state = this.props.filters.query.vehicleJourneyName
    this.updateValue = this.updateValue.bind(this)
  }

  updateValue(e) {
    let val = {}
    val[e.target.name] = parseInt(e.target.value)
    let newState = _.assign({}, this.state, val)
    this.setState(newState)
    this.props.onSelect2VehicleJourneyName(newState)
  }

  render() {

    return (
      <div className="input-group-split-3">
        <label className='w30'>Id course: </label>
        <div className="input-group w70">
          <input
            type='number'
            name="min"
            className='form-control'
            value={this.props.filters.query.vehicleJourneyName.min}
            onChange={this.updateValue}
          />
          <div className="input-group-text">à</div>
          <input
            type='number'
            name="max"
            className='form-control'
            value={this.props.filters.query.vehicleJourneyName.max}
            onChange={this.updateValue}
            />
        </div>
      </div>
    )
  }
}

const formatRepo = (props) => {
  if(props.text) return props.text
}
