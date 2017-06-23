
isEmpty = (x) -> x == ''

daySelector   = '#q_contains_date_3i'
monthSelector = '#q_contains_date_2i'
yearSelector  = '#q_contains_date_1i'

dateSelectors = [ daySelector, monthSelector, yearSelector ]

checkDate = (args...) ->
  vals = args.map((ele) -> ele.val())
  return if vals.find( isEmpty ) == "" # no checking needed, no checking possible yet

  dates = vals.map (x) -> parseInt(x)
  return if isLegalDate(dates)
  $('.alert').text('illegal date')
  $('.alert').show()

legalDaysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

isLeapYear = (year) ->
  (year % 4 == 0) && ((year % 100 != 0) || (year % 1000 == 0))

isLegalDate = (dates) ->
  [day, month, year] = dates
  return true if legalDaysPerMonth[month-1] >= day
  return true if day == 29 && isLeapYear(year)
  false

defineChangeHandler = (selector) ->
  $(selector).on 'change', ->
    checkDate $(daySelector), $(monthSelector), $(yearSelector)

$ ->
  defineChangeHandler selector for selector in dateSelectors
