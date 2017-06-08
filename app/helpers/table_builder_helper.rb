module TableBuilderHelper
  # TODO: rename this after migration from `table_builder`
  def table_builder_2(
    collection,
    columns,
    sortable: true,
    selectable: false,  # TODO: is this necessary?
    # selection_actions: [] ## this has been gotten rid of. The element based on this should be created elsewhere
    links: [],  # links: or actions: ? I think 'links' is better since 'actions' evokes Rails controller actions and we want to put `link_to`s here
    sort_by: {},  # { column: 'name', direction: 'desc' }
    cls: ''  # can we rename this to "class"?
# sort column
# sort direction

# TODO: add `linked_column` or some such attribute that defines which column should be linked and what method to call to get it
  )
    # TODO: Maybe move this to a private method
    head = content_tag :thead do
      content_tag :tr do
        hcont = []

        # Adds checkbox to table header
        if !selectable
          cbx = content_tag :div, '', class: 'checkbox' do
            check_box_tag('0', 'all').concat(content_tag(:label, '', for: '0'))
          end
          hcont << content_tag(:th, cbx)
        end

        columns.map do |k, v|
          # These columns are hard-coded to not be sortable
          if ["ID Codif", "Oid", "OiD", "ID Reflex", "Arrêt de départ", "Arrêt d'arrivée", "Période de validité englobante", "Période englobante", "Nombre de courses associées", "Journées d'application"].include? k
            hcont << content_tag(:th, k)
          else
            hcont << content_tag(:th, sortable_columns(collection, k))
          end
        end
        # Inserts a blank column for the gear menu
        hcont << content_tag(:th, '') if links.any?

        hcont.join.html_safe
      end
    end

    # TODO: refactor
    body = content_tag :tbody do
      collection.collect do |item|

        content_tag :tr do
          bcont = []

          # Adds item checkboxes whose value = the row object's id
          # Apparently the object id is also used in the HTML id attribute without any prefix
          if !selectable
            # TODO: Extract method `build_checkbox(attribute)`
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
            # if so this column's contents get transformed into a link to the object
            if attribute == 'name' or attribute == 'comment'
              lnk = []

              # #is_a? ? ; or ?
              unless item.class == Calendar or item.class == Referential
                if current_referential
                  lnk << current_referential
                  lnk << item.line if item.respond_to? :line
                  lnk << item.route.line if item.class == Chouette::RoutingConstraintZone
                  lnk << item if item.respond_to? :line_referential
                  lnk << item.stop_area if item.respond_to? :stop_area
                  lnk << item if item.respond_to? :stop_points or item.class.to_s == 'Chouette::TimeTable'
                elsif item.respond_to? :referential
                  lnk << item.referential
                end
              else
                lnk << item
              end

              bcont << content_tag(:td, link_to(value, lnk), title: 'Voir')
            else
              bcont << content_tag(:td, value)
            end
          end
          bcont << content_tag(:td, links_builder(item, links), class: 'actions') if links.any?

          bcont.join.html_safe
        end
      end.join.html_safe
    end

    content_tag :table, head + body, class: cls
  end
end
