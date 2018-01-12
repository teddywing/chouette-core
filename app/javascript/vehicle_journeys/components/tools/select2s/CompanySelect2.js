import _ from 'lodash'
import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Select2 from 'react-select2-wrapper'
import actions from '../../../actions'

// get JSON full path
let origin = window.location.origin
let path = window.location.pathname.split('/', 3).join('/')
let line = window.location.pathname.split('/')[4]


export default class BSelect4 extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <Select2
        data={(this.props.company) ? [this.props.company.name] : undefined}
        value={(this.props.company) ? this.props.company.name : undefined}
        onSelect={(e) => this.props.onSelect2Company(e) }
        onUnselect={() => this.props.onUnselect2Company()}
        disabled={!this.props.editMode && this.props.editModal}
        multiple={false}
        ref='company_id'
        options={{
          allowClear: this.props.editMode,
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
                q: { name_cont: params.term},
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