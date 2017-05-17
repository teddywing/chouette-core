var _ = require('lodash')
var React = require('react')
var PropTypes = require('react').PropTypes
var Select2 = require('react-select2')

// get JSON full path
var origin = window.location.origin
var path = window.location.pathname.split('/', 7).join('/')


class BSelect4b extends React.Component{
  constructor(props) {
    super(props)
  }
  humanOID(oid) {
    var a = oid.split(':')
    return a[a.length - 1]
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
          ajax: {
            url: origin + path + '/vehicle_journeys.json',
            dataType: 'json',
            delay: '500',
            data: function(params) {
              return {
                q: {objectid_cont: params.term},
              };
            },
            processResults: function(data, params) {
              return {
                results: data.vehicle_journeys.map(
                  item => _.assign(
                    {},
                    item,
                    { id: item.objectid, text: _.last(_.split(item.objectid, ':')) }
                  )
                )
              };
            },
            cache: true
          },
          minimumInputLength: 2,
          templateResult: formatRepo
        }}
      />
    )
  }
}

const formatRepo = (props) => {
  if(props.text) return props.text
}

module.exports = BSelect4b
