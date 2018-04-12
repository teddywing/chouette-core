import React, { Component } from 'react'
import PropTypes from 'prop-types'
import AddStopPoint from '../containers/AddStopPoint'
import VisibleStopPoints from'../containers/VisibleStopPoints'
import clone  from '../../helpers/clone'

export default class App extends Component {

  render() {
    return (
      <div>
        <VisibleStopPoints />
        <AddStopPoint />
      </div>
    )
  }
}
