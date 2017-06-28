window.legalDaysPerMonth =
  false: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
  true:  [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]


window.legal
window.correctDay = (dateValues) ->
  [day, month, year] = dateValues
  return day unless day > 0 && month > 0 && year > 0

  legallyMaximumDay = legalDaysPerMonth[isLeapYear(year)][month - 1]
  Math.min day, legallyMaximumDay

window.isLeapYear = (year) ->
  (year % 4 == 0) && ((year % 400 == 0) || (year % 100 != 0))

window.smartCorrectDate = ->
  allSelectors = $(@).parent().children('select')
  allVals      = allSelectors.map (index, sel) ->
    parseInt($(sel).val())
  correctedDay = correctDay allVals
  daySelector  = allSelectors.first()
  $(daySelector).val(correctedDay)

$ ->
  $(document).on 'change', '.smart_date select', smartCorrectDate
