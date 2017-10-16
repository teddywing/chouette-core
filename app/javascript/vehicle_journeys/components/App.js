import React from 'react'
import VehicleJourneysList from '../containers/VehicleJourneysList'
import Navigate from '../containers/Navigate'
import ToggleArrivals from '../containers/ToggleArrivals'
import Filters from '../containers/Filters'
import SaveVehicleJourneys from '../containers/SaveVehicleJourneys'
import ConfirmModal from '../containers/ConfirmModal'
import Tools from '../containers/Tools'

export default function App() {
  return (
    <div>

      <div className='row'>
        <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
          <ToggleArrivals />
        </div>
        <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right'>
          <Navigate />
        </div>
      </div>

      <Filters />
      <VehicleJourneysList />

      <div className='row'>
        <div className='col-lg-12 text-right'>
          <Navigate />
        </div>
      </div>

      <SaveVehicleJourneys />
      <Tools />

      <ConfirmModal />
    </div>
  )
}