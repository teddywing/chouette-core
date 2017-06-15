module LinksHelper
  def destroy_link_content
    content_tag(:span, nil, class: 'fa fa-trash') + t('actions.destroy')
  end
end
