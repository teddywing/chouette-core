var React = require('react')
var { Component, PropTypes } = require('react')
var AddStopPoint = require('../containers/AddStopPoint')
var VisibleStopPoints = require('../containers/VisibleStopPoints')
const clone = require('../../helpers/clone')
const I18n = clone(window , "I18n", true)

class App extends Component {

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

module.exports = App
