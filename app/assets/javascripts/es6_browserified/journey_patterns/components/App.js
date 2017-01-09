var React = require('react')
var AddJourneyPattern = require('../containers/AddJourneyPattern')
var Navigate = require('../containers/Navigate')
var Modal = require('../containers/Modal')
var ConfirmModal = require('../containers/ConfirmModal')
var SaveJourneyPattern = require('../containers/SaveJourneyPattern')
var JourneyPatternList = require('../containers/JourneyPatternList')

const App = () => (
  <div>
    <div className='clearfix' style={{ marginBottom: 10 }}>
      <Navigate />
      <AddJourneyPattern />
    </div>
    <JourneyPatternList />
    <SaveJourneyPattern />
    <ConfirmModal />
    <Modal/>
  </div>
)

module.exports = App
