var React = require('react')
var AddJourneyPattern = require('../containers/AddJourneyPattern')
var Navigate = require('../containers/Navigate')
var JourneyPatternList = require('../containers/JourneyPatternList')

const App = () => (
  <div>
    <div classNam='clearfix' style={{ marginBottom: 10 }}>
      <AddJourneyPattern />
      <Navigate />
    </div>
    <JourneyPatternList />
  </div>
)

module.exports = App
