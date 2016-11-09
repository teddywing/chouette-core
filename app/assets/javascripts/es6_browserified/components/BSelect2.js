var React = require('react')
var PropTypes = require('react').PropTypes
var Select2 = require('react-select2')

// get JSON full path
var origin = window.location.origin
var path = window.location.pathname.split('/', 3).join('/')

class BSelect3 extends React.Component{
  constructor(props) {
    super(props)
    this.state = {
      edit: false
    }
  }
  onToggleEdit(e) {
    e.preventDefault()
    this.setState({edit: !this.state.edit})
  }
  onChange(e) {
    console.log(e.currentTarget.value, e.currentTarget.textContent)
    this.props.onChange(this.props.index, {text: e.currentTarget.textContent, id: e.currentTarget.value})
    this.setState({edit: false})
  }
  render() {
    if(this.state.edit)
      return (
        <div>
          <BSelect2 {...this.props} onSelect={ this.onChange.bind(this) }/>
        </div>
      )
    else
      return (
        <div>
          <span
            title="Cliquez pour changer l'arrêt"
            style={{cursor: 'pointer', display: 'block'}}
            onClick={this.onToggleEdit.bind(this)}
          >
            {this.props.value.text}
          </span>
        </div>
      )
  }
}

const BSelect2 = (props) => {
  return (
    <Select2
      value={props.value.id}
      onSelect={ props.onSelect }
      options={{
        placeholder: 'Sélectionnez un arrêt existant...',
        theme: 'bootstrap',
        ajax: {
          url: origin + path + '/autocomplete_stop_areas.json',
          dataType: 'json',
          delay: '500',
          data: function(params) {
            return {
              q: params.term
            };
          },
          processResults: function(data, params) {
            return {
              results: data.map(
                item => Object.assign(
                  {},
                  item,
                  { text: item.name + ", " + item.zip_code + " " + item.short_city_name }
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

// to fix: this is for custom results return
const formatRepo = (props) => {
  if(props.text) return props.text
  // console.log(props)
  // return (
  //   <div>
  //     {props.short_name}
  //     <small><em>{props.zip_code} {props.short_city_name}</em></small>
  //   </div>
  // )
}

module.exports = BSelect3
