module RefobjectsHelper

  def table_builder collection, columns, actions = [], cls = nil
    return unless collection.present?

    head = content_tag :thead do
      content_tag :tr do
        attributes_head = columns.collect do |col|
          content_tag :th, col.to_s.titleize
        end.join.html_safe
        links_head = content_tag :th, "Actions" if actions.any?
        attributes_head + links_head
      end
    end

    body = content_tag :tbody do
      collection.collect { |item|
        content_tag :tr do
          attributes = columns.collect { |col|
            content_tag(:td, item.try(col))
          }.join.html_safe

          # Build links
          links = content_tag :td, autolinks_builder(item, actions, :xs), class: 'text-center' if actions.any?

          attributes + links
        end
      }.join.html_safe
    end

    # content_tag :table, head + body, class: cls
    content_tag :table, "pouet"
  end

  def autolinks_builder(item, actions, cls)
    link = []

    actions.each do |action|
      if action == "show"
        showlink = link_to(company_path(item), class: 'btn btn-default') do
          content_tag :span, "", class: 'fa fa-eye'
        end
        link << showlink
      elsif action == "edit"
        editlink = link_to(edit_company_path(item), class: 'btn btn-default') do
          content_tag :span, "", class: 'fa fa-pencil'
        end
        link << editlink
      elsif action == "delete"
        deletelink = link_to(company_path(item), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-default') do
          content_tag :span, "", class: 'fa fa-trash-o'
        end
        link << deletelink
      end
    end

    content_tag :div, class: "btn-group btn-group-#{cls}" do
      link.join().html_safe
    end
  end

end
