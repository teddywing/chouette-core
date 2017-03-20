var React = require('react')
var PropTypes = require('react').PropTypes
var Select2 = require('react-select2')


// get JSON full path
var origin = window.location.origin
var path = window.location.pathname.split('/', 3).join('/')


class BSelect3 extends React.Component{
  constructor(props) {
    super(props)
  }
  onChange(e) {
    this.props.onChange(this.props.index, {
      text: e.currentTarget.textContent,
      stoparea_id: e.currentTarget.value,
      user_objectid: e.params.data.user_objectid,
      longitude: e.params.data.longitude,
      latitude: e.params.data.latitude,
      name: e.params.data.name,
      short_name: e.params.data.short_name,
      city_name: e.params.data.city_name,
      area_type: e.params.data.area_type,
      zip_code: e.params.data.zip_code
    })
  }

  render() {
    if(this.props.value.edit)
      return (
        <div className='select2-bootstrap-append'>
          <BSelect2 {...this.props} onSelect={ this.onChange.bind(this) }/>
        </div>
      )
    else
      if(!this.props.value.stoparea_id)
        return (
          <div>
            <BSelect2 {...this.props} onSelect={ this.onChange.bind(this) }/>
          </div>
        )
      else
        return (
          <a
            className='navlink'
            href={origin + path + '/stop_areas/' + this.props.value.stoparea_id}
            title="Voir l'arrêt"
          >
            {this.props.value.text}
          </a>
        )
  }
}

class BSelect2 extends React.Component{
  componentDidMount() {
    this.refs.newSelect.el.select2('open')
  }

  render() {
    return (
      <Select2
        value={ this.props.value.stoparea_id }
        onSelect={ this.props.onSelect }
        ref='newSelect'
        options={{
          placeholder: 'Sélectionnez un arrêt existant...',
          allowClear: true,
          language: 'fr', /* Doesn't seem to work... :( */
          theme: 'bootstrap',
          width: '100%',
          ajax: {
            url: origin + path + '/autocomplete_stop_areas.json',
            dataType: 'json',
            delay: '500',
            data: function(params) {
              return {
                q: params.term,
                target_type: 'zdep'
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
}

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
