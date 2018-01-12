import React, { Component } from 'react'
import PropTypes from 'prop-types'
import AddStopPoint from '../containers/AddStopPoint'
import VisibleStopPoints from'../containers/VisibleStopPoints'
import clone  from '../../helpers/clone'
const I18n = clone(window , "I18n", true)

export default class App extends Component {

  getChildContext() {
    return { I18n }
  }

  render() {
    return (
      <div>
        <VisibleStopPoints />
        <AddStopPoint />
      </div>
    )
  }
}

App.childContextTypes = {
  I18n: PropTypes.object
}
