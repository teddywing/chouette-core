var _ = require('lodash')
var React = require('react')
var PropTypes = require('react').PropTypes
var Select2 = require('react-select2')

// get JSON full path
var origin = window.location.origin
var path = window.location.pathname.split('/', 3).join('/')
var line = window.location.pathname.split('/')[4]


class BSelect4 extends React.Component{
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <Select2
        data={(this.props.company) ? [this.props.company.name] : undefined}
        value={(this.props.company) ? this.props.company.name : undefined}
        onSelect={(e) => this.props.onSelect2Company(e) }
        multiple={false}
        ref='company_id'
        options={{
          allowClear: false,
          theme: 'bootstrap',
          width: '100%',
          placeholder: 'Filtrer par transporteur...',
          language: require('./fr'),
          ajax: {
            url: origin + path + '/companies.json' + '?line_id=' + line,
            dataType: 'json',
            delay: '500',
            data: function(params) {
              return {
                q: {name_cont: params.term},
              };
            },
            processResults: function(data, params) {

              return {
                results: data.map(
                  item => _.assign(
                    {},
                    item,
                    {text: item.name}
                  )
                )
              };
            },
            cache: true
          },
          minimumInputLength: 3,
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
