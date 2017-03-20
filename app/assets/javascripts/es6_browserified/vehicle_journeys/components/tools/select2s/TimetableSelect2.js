var React = require('react')
var PropTypes = require('react').PropTypes
var Select2 = require('react-select2')

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
          ajax: {
            url: origin + path + this.props.chunkURL,
            dataType: 'json',
            delay: '500',
            data: function(params) {
              return {
                q: {comment_cont: params.term},
              };
            },
            processResults: function(data, params) {

              return {
                results: data.map(
                  item => Object.assign(
                    {},
                    item,
                    {text: item.comment}
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
