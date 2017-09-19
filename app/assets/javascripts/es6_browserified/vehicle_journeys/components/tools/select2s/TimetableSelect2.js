var _ = require('lodash')
var React = require('react')
var PropTypes = require('react').PropTypes
var Select2 = require('react-select2')
var humanOID = require('../../../actions').humanOID

// get JSON full path
var origin = window.location.origin
var path = window.location.pathname.split('/', 3).join('/')


class BSelect4 extends React.Component{
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <Select2
        data={(this.props.isFilter) ? [this.props.filters.query.timetable.comment] : undefined}
        value={(this.props.isFilter) ? this.props.filters.query.timetable.comment : undefined}
        onSelect={(e) => this.props.onSelect2Timetable(e) }
        multiple={false}
        ref='timetable_id'
        options={{
          allowClear: false,
          theme: 'bootstrap',
          width: '100%',
          placeholder: 'Filtrer par calendrier...',
          language: require('./fr'),
          ajax: {
            url: origin + path + this.props.chunkURL,
            dataType: 'json',
            delay: '500',
            data: function(params) {
              let newParmas = params.term.split(" ")
              return {
                q: {
                  objectid_cont_any: newParmas,
                  comment_cont_any: newParmas,
                  m: 'or'
                }
              };
            },
            processResults: function(data, params) {
              return {
                results: data.map(
                  item => _.assign(
                    {},
                    item,
                    {text: '<strong>' + "<span class='fa fa-circle' style='color:" + (item.color ? item.color : '#4B4B4B') + "'></span> " + item.comment + ' - ' + humanOID(item.objectid) + '</strong><br/><small>' + (item.day_types ? item.day_types.match(/[A-Z]?[a-z]+/g).join(', ') : "") + '</small>'}
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
