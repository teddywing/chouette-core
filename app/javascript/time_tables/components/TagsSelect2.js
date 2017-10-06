import React, { PropTypes, Component } from 'react'
import _ from 'lodash'
import Select2 from 'react-select2-wrapper'

// get JSON full path
let origin = window.location.origin
let path = window.location.pathname.split('/', 4).join('/')

export default class TagsSelect2 extends Component {
  constructor(props, context) {
    super(props, context)
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
        data={(this.props.initialTags.length) ? this.mapKeys(this.props.initialTags) : undefined}
        onSelect={(e) => this.props.onSelect2Tags(e)}
        onUnselect={(e) => setTimeout( () => this.props.onUnselect2Tags(e, 150))}
        multiple={true}
        ref='tags_id'
        options={{
          tags:true,
          createTag: function(params) {
            return {name: params.term, text: params.term, id: params.term}
          },
          allowClear: true,
          theme: 'bootstrap',
          width: '100%',
          placeholder: this.context.I18n.time_tables.edit.select2.tag.placeholder,
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
              let items = _.filter(data, ({name}) => name.includes(params.term) )
              return {
                results: items.map(
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
          minimumInputLength: 1,
          templateResult: formatRepo
        }}
      />
    )
  }
}

const formatRepo = (props) => {
  if(props.name) return props.name
}

TagsSelect2.contextTypes = {
  I18n: PropTypes.object
}