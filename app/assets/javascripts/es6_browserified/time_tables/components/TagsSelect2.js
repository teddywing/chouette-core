var _ = require('lodash')
var React = require('react')
var PropTypes = require('react').PropTypes
var Select2 = require('react-select2')

// get JSON full path
var origin = window.location.origin
var path = window.location.pathname.split('/', 4).join('/')
var _ = require('lodash')

class TagsSelect2 extends React.Component{
  constructor(props) {
    super(props)
  }

  mapKeys(array){
    return array.map((item) =>
      _.mapKeys(item, (v, k) =>
        ((k == 'name') ? 'text' : k)
      )
    )
  }

  render() {
    return (
      <Select2
        value={(this.props.tags.length) ? _.map(this.props.tags, 'id') : undefined}
        data={(this.props.tags.length) ? this.mapKeys(this.props.tags) : undefined}
        onSelect={(e) => this.props.onSelect2Tags(e)}
        onUnselect={(e) => setTimeout( () => this.props.onUnselect2Tags(e, 150))}
        multiple={true}
        ref='tags_id'
        options={{
          allowClear: true,
          theme: 'bootstrap',
          width: '100%',
          placeholder: 'Cherchez un tag...',
          ajax: {
            url: origin + path + '/tags.json',
            dataType: 'json',
            delay: '500',
            data: function(params) {
              return {
                tag: params.term,
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
  if(props.name) return props.name
}

module.exports = TagsSelect2
