module CustomViewHelper

  def render_custom_view(view)
    view_name = [view, current_organisation.try(:custom_view)].compact.join('_')
    Rails.logger.debug "Render custom view #{view_name}"
    render partial: view_name
  end

end
