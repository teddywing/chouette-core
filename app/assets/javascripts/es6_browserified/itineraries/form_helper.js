const addInput = (name, value, index) => {
  let form = document.querySelector('form')
  let input = document.createElement('input')
  let formatedName = 'route[stop_points_attributes]['+ index.toString()+']['+name+']'
  input.setAttribute('type', 'hidden')
  input.setAttribute('name', formatedName)
  input.setAttribute('value', value)
  form.appendChild(input)
}

module.exports = addInput
