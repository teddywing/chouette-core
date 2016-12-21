var React = require('react')
var AddJourneyPattern = require('../containers/AddJourneyPattern')
var Navigate = require('../containers/Navigate')
var Modal = require('../containers/Modal')
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
    <Modal/>
  </div>
)

module.exports = App
