class TimeTravel
  constructor: (@overview)->
    @container = @overview.container.find('.time-travel')
    @todayBt = @container.find(".today")
    @prevBt = @container.find(".prev-page")
    @nextBt = @container.find(".next-page")
    @initButtons()

  initButtons: ->
    @prevBt.click (e)=>
      @overview.prevPage()
      e.preventDefault()
      false

    @nextBt.click (e)=>
      @overview.nextPage()
      e.preventDefault()
      false

    @todayBt.click (e)=>
      today = new Date()
      month = today.getMonth() + 1
      month = "0#{month}" if month < 10
      day = today.getDate()
      day = "0#{month}" if day < 10
      @overview.showDay "#{today.getFullYear()}-#{month}-#{day}"
      e.preventDefault()
      false

  scrolledTo: (progress)->
    @prevBt.removeClass 'disabled'
    @nextBt.removeClass 'disabled'
    @prevBt.addClass 'disabled' if progress == 0
    @nextBt.addClass 'disabled' if progress == 1

class window.ReferentialOverview
  constructor: (selector)->
    @container = $(selector)
    @timeTravel = new TimeTravel(this)
    @currentOffset = 0

  showDay: (date)->
    day = @container.find(".day.#{date}")
    offset = day.offset().left
    parentOffset = @container.find(".right .inner").offset().left
    @scrollTo parentOffset - offset

  currentOffset: ->
    @container.find(".right .inner").offset().left

  prevPage: ->
    @scrollTo @currentOffset + @container.find(".right").width()

  nextPage: ->
    @scrollTo @currentOffset - @container.find(".right").width()

  minOffset: ->
    @_minOffset ||= @container.find(".right").width() - @container.find(".right .line").width()
    @_minOffset

  scrollTo: (offset)->
    @currentOffset = offset
    @currentOffset = Math.max(@currentOffset, @minOffset())
    @currentOffset = Math.min(@currentOffset, 0)
    @container.find(".right .inner").css "margin-left": "#{@currentOffset}px"
    @timeTravel.scrolledTo 1 - (@minOffset() - @currentOffset) / @minOffset()

export default ReferentialOverview
