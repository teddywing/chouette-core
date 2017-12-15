module BusinessCalendarHelper
  def color_diplsay(color)
    content_tag(:span, '', class: 'fa fa-circle', style: "color:#{color}")
  end
end