module NewapplicationHelper

  # Table Builder
  def table_builder collection, columns, actions, selectable, cls = nil
    return unless collection.present?

    head = content_tag :thead do
      content_tag :tr do
        hcont = []

        if selectable.to_s == 'selectable'
          cbx = content_tag :div, '', class: 'checkbox' do
            check_box_tag('0', 'all').concat(content_tag(:label, '', for: '0'))
          end
          hcont << content_tag(:th, cbx)
        end

        columns.map do |k, v|
          hcont << content_tag(:th, sortable_columns(collection, k))
        end
        hcont << content_tag(:th, '') if actions.any?

        hcont.join.html_safe
      end
    end

    body = content_tag :tbody do
      collection.collect do |item|
        content_tag :tr do
          bcont = []

          if selectable.to_s == 'selectable'
            cbx = content_tag :div, '', class: 'checkbox' do
              check_box_tag(item.try(:id), item.try(:id)).concat(content_tag(:label, '', for: item.try(:id)))
            end
            bcont << content_tag(:td, cbx)
          end

          columns.map do |k, attribute|
            value =
              if Proc === attribute
                attribute.call(item)
              else
                item.try(attribute)
              end
            if attribute == 'name'
              lnk = []
              unless item.class.to_s == 'Calendar' or item.class.to_s == 'Referential'
                if current_referential
                  lnk << current_referential
                  lnk << item.line if item.respond_to? :line
                elsif item.respond_to? :referential
                  lnk << item.referential
                elsif item.respond_to? :line_referential
                  lnk << item.line_referential
                end
              end

              lnk << item

              bcont << content_tag(:td, link_to(value, lnk), title: 'Voir')
            else
              bcont << content_tag(:td, value)
            end
          end
          bcont << content_tag(:td, links_builder(item, actions), class: 'actions') if actions.any?

          bcont.join.html_safe
        end
      end.join.html_safe
    end

    content_tag :table, head + body, class: cls
  end

  def links_builder(item, actions)
    trigger = content_tag :div, class: 'btn dropdown-toggle', data: { toggle: 'dropdown' } do
      content_tag :span, '', class: 'fa fa-cog'
    end

    menu = content_tag :ul, class: 'dropdown-menu' do
      actions.collect do |action|
        polymorph_url = []

        unless [:show, :delete].include? action
          polymorph_url << action
        end

        unless item.class.to_s == 'Calendar' or item.class.to_s == 'Referential'
          if current_referential
            polymorph_url << current_referential
            polymorph_url << item.line if item.respond_to? :line
          elsif item.respond_to? :referential
            polymorph_url << item.referential
          elsif item.respond_to? :line_referential
            polymorph_url << item.line_referential
          end
        end

        polymorph_url << item

        if action == :delete
          if policy(item).present?
            if policy(item).destroy?
              content_tag :li, '', class: 'delete-action' do
                link_to(polymorph_url, method: :delete, data: { confirm: 'Etes-vous sûr(e) de vouloir effectuer cette action ?' }) do
                  txt = t("actions.#{action}")
                  pic = content_tag :span, '', class: 'fa fa-trash'
                  pic + txt
                end
              end
            end
          else
            content_tag :li, '', class: 'delete-action' do
              link_to(polymorph_url, method: :delete, data: { confirm: 'Etes-vous sûr(e) de vouloir effectuer cette action ?' }) do
                txt = t("actions.#{action}")
                pic = content_tag :span, '', class: 'fa fa-trash'
                pic + txt
              end
            end
          end

        elsif action == :edit
          if policy(item).present?
            if policy(item).update?
              content_tag :li, link_to(t("actions.#{action}"), polymorph_url)
            end
          else
            content_tag :li, link_to(t("actions.#{action}"), polymorph_url)
          end
        else
          content_tag :li, link_to(t("actions.#{action}"), polymorph_url)
        end
      end.join.html_safe
    end

    content_tag :div, trigger + menu, class: 'btn-group'

  end

  def sortable_columns collection, key
    direction = (key == params[:sort] && params[:direction] == 'desc') ? 'asc' : 'desc'

    link_to({sort: key, direction: direction}) do
      pic1 = content_tag :span, '', class: "fa fa-sort-asc #{(direction == 'desc') ? 'active' : ''}"
      pic2 = content_tag :span, '', class: "fa fa-sort-desc #{(direction == 'asc') ? 'active' : ''}"

      pics = content_tag :span, pic1 + pic2, class: 'orderers'
      (key.to_s + pics).html_safe
    end
  end

  # Actions on select toolbox
  def select_toolbox actions
    tools = content_tag :ul do
      actions.collect do |action|

        actitem = link_to '#', title: t("actions.#{action}") do
          if action == :edit
            content_tag :span, '', class: 'fa fa-pencil'
          elsif action == :delete
            content_tag :span, '', class: 'fa fa-trash'
          end
        end

        content_tag :li, actitem, class: 'st_action'
      end.join.html_safe

    end
    content_tag :div, '', class: 'select_toolbox' do
      tools.concat(content_tag(:span, "n élément(s) sélectionné(s)", class: 'info-msg'))
    end
  end

  # Replacement message
  def replacement_msg text
    content_tag :div, '', class: 'alert alert-warning' do
      icon = content_tag :span, '', class: 'fa fa-lg fa-info-circle', style: 'margin-right:7px;'
      icon + text
    end
  end

  # PageHeader builder
  def pageheader pageicon, pagetitle, desc, meta, mainaction = nil, &block

    firstRow = content_tag :div, '', class: 'row' do
      # Left part with pageicon & pagetitle & desc
      left = content_tag :div, '', class: 'col-lg-9 col-md-8 col-sm-8 col-xs-7' do
        picon = content_tag :div, '', class: 'page-icon' do
          content_tag :span, '', class: "fa fa-lg fa-#{pageicon}"
        end
        ptitle = content_tag :div, '', class: 'page-title' do
          info = content_tag :span, '', class: 'small fa fa-info-circle', title: desc

          content_tag :h1, pagetitle.concat(info).html_safe
        end

        picon + ptitle
      end
      # Right part with meta & mainaction
      right = content_tag :div, '', class: 'col-lg-3 col-md-4 col-sm-4 col-xs-5 text-right' do
        content_tag :div, '', class: 'page-action' do
          a = content_tag :div, meta.html_safe, class: 'small'
          b = mainaction.try(:html_safe)

          a + b
        end
      end

      left + right
    end

    content_tag :div, '', class: 'page_header' do
      content_tag :div, '', class: 'container-fluid' do
        firstRow + capture(&block)
      end
    end
  end

end
