const addInput = (name, value, index) => {
  let form = document.querySelector('form')
  let input = document.createElement('input')
  input.setAttribute('type', 'hidden')
  input.setAttribute('name', `route[stop_points_attributes][${index}][${name}]`)
  input.setAttribute('value', value)
  form.appendChild(input)
}

export default addInput
