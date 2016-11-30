module NewfrontHelper

  # Table Builder
  def table_builder collection, columns, actions, cls = nil
    return unless collection.present?

    head = content_tag :thead do
      content_tag :tr do
        hcont = []
        columns.map do |k, v|
          # hcont << content_tag(:th, k.to_s.titleize)
          hcont << content_tag(:th, sortable_columns(collection, k))
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

        unless [:show, :delete].include? action
          polymorph_url << action
        end

        if current_referential
          polymorph_url << current_referential
        elsif item.respond_to? :referential
          polymorph_url << item.referential
        elsif item.respond_to? :line_referential
          polymorph_url << item.line_referential
        end

        polymorph_url << item

        if action == :delete
          if policy(item).present?
            if policy(item).destroy?
              content_tag :li, link_to(t("table.#{action}"), polymorph_url, method: :delete, data: { confirm: 'Etes-vous sûr(e) de vouloir effectuer cette action ?' })
            end
          else
            content_tag :li, link_to(t("table.#{action}"), polymorph_url, method: :delete, data: { confirm: 'Etes-vous sûr(e) de vouloir effectuer cette action ?' })
          end

        elsif action == :edit
          if policy(item).present?
            if policy(item).update?
              content_tag :li, link_to(t("table.#{action}"), polymorph_url)
            end
          else
            content_tag :li, link_to(t("table.#{action}"), polymorph_url)
          end
        else
          content_tag :li, link_to(t("table.#{action}"), polymorph_url)
        end
      end.join.html_safe
    end

    content_tag :div, trigger + menu, class: 'btn-group btn-group-xs'

  end

  def sortable_columns collection, key
    direction = (key == params[:sort] && params[:direction] == 'desc') ? 'asc' : 'desc'

    icon = 'sort-desc' if direction == 'asc'
    icon = 'sort-asc' if direction == 'desc'

    link_to({sort: key, direction: direction}) do
      pic = content_tag :span, '', class: "fa fa-#{icon}", style: 'margin-left:5px'
      (key.to_s.titleize + pic).html_safe
    end
  end

  # Replacement message
  def replacement_msg text
    content_tag :div, '', class: 'alert alert-warning' do
      icon = content_tag :span, '', class: 'fa fa-lg fa-info-circle', style: 'margin-right:7px;'
      icon + text
    end
  end

end
