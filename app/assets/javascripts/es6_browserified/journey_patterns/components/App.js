var React = require('react')
var AddJourneyPattern = require('../containers/AddJourneyPattern')
var JourneyPatternList = require('../containers/JourneyPatternList')

const App = () => (
  <div>
    <AddJourneyPattern />
    <JourneyPatternList />
  </div>
)

module.exports = App
