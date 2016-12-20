var React = require('react')
var AddJourneyPattern = require('../containers/AddJourneyPattern')
var Navigate = require('../containers/Navigate')
var SaveJourneyPattern = require('../containers/SaveJourneyPattern')
var JourneyPatternList = require('../containers/JourneyPatternList')

const App = () => (
  <div>
    <div className='clearfix' style={{ marginBottom: 10 }}>
      <AddJourneyPattern />
      <Navigate />
    </div>
    <JourneyPatternList />
    <SaveJourneyPattern />
  </div>
)

module.exports = App
