module NewfrontHelper

  def table_builder collection, columns, actions, cls = nil
    return unless collection.present?

    head = content_tag :thead do
      content_tag :tr do
        hcont = []
        columns.map do |k, v|
          hcont << content_tag(:th, k.to_s.titleize)
        end
        hcont << content_tag(:th, 'Actions', class: 'text-center') if actions.any?

        hcont.join.html_safe
      end
    end

    body = content_tag :tbody do
      collection.collect do |item|
        content_tag :tr do
          bcont = []
          columns.map do |k, attribute|
            value =
              if Proc === attribute
                attribute.call(item)
              else
                item.try(attribute)
              end
            bcont << content_tag(:td, value)
          end
          bcont << content_tag(:td, links_builder(item, actions), class: 'text-center') if actions.any?

          bcont.join.html_safe
        end
      end.join.html_safe
    end

    content_tag :table, head + body, class: cls
  end

  def links_builder(item, actions)
    trigger = content_tag :div, class: 'btn btn-primary dropdown-toggle', data: { toggle: 'dropdown' } do
      a = content_tag :span, '', class: 'fa fa-bars'
      b = content_tag :span, '', class: 'caret'
      a + b
    end

    menu = content_tag :ul, class: 'dropdown-menu' do
      actions.collect do |action|
        polymorph_url = []

        polymorph_url << action if action != :show
        if current_referential
          polymorph_url << current_referential
        elsif item.respond_to? :referential
          polymorph_url << item.referential
        end

        polymorph_url << item

        content_tag :li, link_to(action, polymorph_url)
      end.join.html_safe
    end

    content_tag :div, trigger + menu, class: 'btn-group btn-group-xs'

  end

end
