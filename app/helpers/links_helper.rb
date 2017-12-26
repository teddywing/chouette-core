module LinksHelper
  def custom_link_content(translation_key, klass, extra_class: nil)
    klass = ["fa", "fa-#{klass}", "mr-xs", extra_class].compact.join(" ")
    content_tag(:span, nil, class: klass) + t(translation_key)
  end

  def destroy_link_content(translation_key = 'actions.destroy')
    custom_link_content translation_key, 'trash'
  end

  def deactivate_link_content(translation_key = 'actions.deactivate')
    custom_link_content translation_key, 'power-off', extra_class: "text-danger"
  end

  def activate_link_content(translation_key = 'actions.activate')
    custom_link_content translation_key, 'power-off', extra_class: "text-success"
  end
end
