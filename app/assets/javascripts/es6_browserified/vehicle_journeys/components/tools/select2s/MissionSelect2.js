var _ = require('lodash')
var React = require('react')
var PropTypes = require('react').PropTypes
var Select2 = require('react-select2')

// get JSON full path
var origin = window.location.origin
var path = window.location.pathname.split('/', 7).join('/')


class BSelect4 extends React.Component{
  constructor(props) {
    super(props)
  }


  render() {
    return (
      <Select2
        data={(this.props.isFilter) ? [this.props.filters.query.journeyPattern.published_name] : ((this.props.selection.selectedJPModal) ? [this.props.selection.selectedJPModal.published_name] : undefined)}
        value={(this.props.isFilter) ? this.props.filters.query.journeyPattern.published_name : ((this.props.selection.selectedJPModal) ? this.props.selection.selectedJPModal.published_name : undefined) }
        onSelect={(e) => this.props.onSelect2JourneyPattern(e)}
        multiple={false}
        ref='journey_pattern_id'
        options={{
          allowClear: false,
          theme: 'bootstrap',
          placeholder: 'Filtrer par code, nom ou OID de mission...',
          language: require('./fr'),
          width: '100%',
          ajax: {
            url: origin + path + '/journey_patterns_collection.json',
            dataType: 'json',
            delay: '500',
            data: function(params) {
              return {
                q: {published_name_or_objectid_or_registration_number_cont: params.term},
              };
            },
            processResults: function(data, params) {
              return {
                results: data.map(
                  item => _.assign(
                    {},
                    item,
                    { text: "<strong>" + item.published_name + _.last(_.split(item.object_id, ':')) + "</strong><br/><small>" + item.registration_number + "</small>" }
                  )
                )
              };
            },
            cache: true
          },
          minimumInputLength: 1,
          escapeMarkup: function (markup) { return markup; },
          templateResult: formatRepo
        }}
      />
    )
  }
}

const formatRepo = (props) => {
  if(props.text) return props.text
}

module.exports = BSelect4
