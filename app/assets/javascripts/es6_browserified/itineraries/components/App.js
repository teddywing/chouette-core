var React = require('react')
var AddStopPoint = require('../containers/AddStopPoint')
var VisibleStopPoints = require('../containers/VisibleStopPoints')

const App = () => (
  <div>
    <AddStopPoint />
    <VisibleStopPoints />
  </div>
)

module.exports = App
