import { combineReducers } from 'redux'
import vehicleJourneys from './vehicleJourneys'
import pagination from './pagination'
import modal from './modal'
import status from './status'
import filters from './filters'
import editMode from './editMode'
import stopPointsList from './stopPointsList'

const vehicleJourneysApp = combineReducers({
  vehicleJourneys,
  pagination,
  modal,
  status,
  filters,
  editMode,
  stopPointsList
})

export default vehicleJourneysApp
