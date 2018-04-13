window.legalDaysPerMonth =
  false: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
  true:  [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

window.correctDay = (dateValues) ->
  [day, month, year] = dateValues
  return day unless day > 0 && month > 0 && year > 0

  legallyMaximumDay = legalDaysPerMonth[isLeapYear(year)][month - 1]
  Math.min day, legallyMaximumDay

window.isLeapYear = (year) ->
  (year % 4 == 0) && ((year % 400 == 0) || (year % 100 != 0))

window.smartCorrectDate = ->
  allSelectors = $(@).parent().children('select')

  yearSelect = allSelectors.filter("[name$='(1i)]']")
  monthSelect = allSelectors.filter("[name$='(2i)]']")
  daySelect = allSelectors.filter("[name$='(3i)]']")
  # We expect [day, month, year], so french
  allVals      = [daySelect, monthSelect, yearSelect].map (sel, index) ->
    parseInt(sel.val())

  correctedDay = correctDay allVals
  daySelect.val(correctedDay)

$ ->
  $(document).on 'change', '.smart_date select', smartCorrectDate
