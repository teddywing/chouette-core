var React = require('react')
var AddJourneyPattern = require('../containers/AddJourneyPattern')
var Navigate = require('../containers/Navigate')
var JourneyPatternList = require('../containers/JourneyPatternList')

const App = () => (
  <div>
    <AddJourneyPattern />
    <Navigate />
    <JourneyPatternList />
  </div>
)

module.exports = App
