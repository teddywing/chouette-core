var React = require('react')
var AddJourneyPattern = require('../containers/AddJourneyPattern')
var Navigate = require('../containers/Navigate')
var Modal = require('../containers/Modal')
var ConfirmModal = require('../containers/ConfirmModal')
var SaveJourneyPattern = require('../containers/SaveJourneyPattern')
var JourneyPatternList = require('../containers/JourneyPatternList')

const App = () => (
  <div>
    <Navigate />
    <JourneyPatternList />
    <Navigate />
    <AddJourneyPattern />
    <SaveJourneyPattern />
    <ConfirmModal />
    <Modal/>
  </div>
)

module.exports = App
