import _ from 'lodash'
import React, { PropTypes, Component } from 'react'
import Select2 from 'react-select2'
import actions from '../../../actions'

// get JSON full path
let origin = window.location.origin
let path = window.location.pathname.split('/', 7).join('/')


export default class BSelect4b extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <Select2
        data={(this.props.isFilter) ? [this.props.filters.query.vehicleJourney.objectid] : undefined}
        value={(this.props.isFilter) ? this.props.filters.query.vehicleJourney.objectid : undefined}
        onSelect={(e) => this.props.onSelect2VehicleJourney(e)}
        multiple={false}
        ref='vehicle_journey_objectid'
        options={{
          allowClear: false,
          theme: 'bootstrap',
          placeholder: 'Filtrer par ID course...',
          width: '100%',
          language: require('./fr'),
          ajax: {
            url: origin + path + '/vehicle_journeys.json',
            dataType: 'json',
            delay: '500',
            data: function(params) {
              return {
                q: { objectid_cont: params.term},
              };
            },
            processResults: function(data, params) {
              return {
                results: data.vehicle_journeys.map(
                  item => _.assign(
                    {},
                    item,
                    { id: item.objectid, text: item.short_id }
                  )
                )
              };
            },
            cache: true
          },
          minimumInputLength: 1,
          templateResult: formatRepo
        }}
      />
    )
  }
}

const formatRepo = (props) => {
  if(props.text) return props.text
}