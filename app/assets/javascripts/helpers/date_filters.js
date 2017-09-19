const DateFilter = function(buttonId, message, ...inputIds) {
  this.buttonId = buttonId
  this.inputIds = inputIds
  this.message = message

  const getVal = (str, key) => {
    let newStr = str.replace(/NUM/, key)
    return $(newStr).val()
  }

  const getDates = () => {
    return this.inputIds.reduce((arr, id) => {
      let newIds = [1, 2, 3].map(key => getVal(id, key))
      arr.push(...newIds)
      return arr
    },[])
  }

  const allInputFilled = () => {
    return getDates().every(date => !!date)
  }

  const noInputFilled = () => {
    return getDates().every(date => !date)
  }

  const execute = () => {
    $(this.buttonId).on("click", (e) => {
      if (allInputFilled() == false && noInputFilled() == false) {
        e.preventDefault()
        alert(this.message)
      }
    })
  }
  return execute
}

module.exports = DateFilter
