module TableBuilderHelper
  # TODO: rename this after migration from `table_builder`
  def table_builder_2(
    collection,
    columns,
    current_referential: nil,
    sortable: true,
    selectable: false,
    # selection_actions: [] ## this has been gotten rid of. The element based on this should be created elsewhere
    links: [],  # links: or actions: ? I think 'links' is better since 'actions' evokes Rails controller actions and we want to put `link_to`s here
    sort_by: {},  # { column: 'name', direction: 'desc' }
    cls: ''  # can we rename this to "class"?
      # ^^ rename to html_options = {} at the end of the non-keyword arguments? Hrm, not a fan of combining hash args and keyword args
# sort column
# sort direction

# TODO: add `linked_column` or some such attribute that defines which column should be linked and what method to call to get it
  )

    content_tag :table,
      thead(collection, columns, selectable, links.any?) +
        tbody(collection, columns, selectable, links),
      class: cls
  end

  private

  def thead(collection, columns, selectable, has_links)
    content_tag :thead do
      content_tag :tr do
        hcont = []

        # Adds checkbox to table header
        if selectable
          hcont << content_tag(:th, checkbox(id_name: '0', value: 'all'))
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
        hcont << content_tag(:th, '') if has_links

        hcont.join.html_safe
      end
    end
  end

  def tbody(collection, columns, selectable, links)
    # TODO: refactor
    content_tag :tbody do
      collection.collect do |item|

        content_tag :tr do
          bcont = []

          if selectable
            bcont << content_tag(
              :td,
              checkbox(id_name: item.try(:id), value: item.try(:id))
            )
          end

          columns.map do |k, attribute|
            value =
              if Proc === attribute
                attribute.call(item)
              else
                item.try(attribute)
              end
            # if so this column's contents get transformed into a link to the object
            if attribute == 'name' || attribute == 'comment'
              lnk = []

              unless item.is_a?(Calendar) || item.is_a?(Referential)
                if current_referential
                  lnk << current_referential
                  lnk << item.line if item.respond_to? :line
                  lnk << item.route.line if item.is_a?(Chouette::RoutingConstraintZone)
                  lnk << item if item.respond_to? :line_referential
                  lnk << item.stop_area if item.respond_to? :stop_area
                  lnk << item if item.respond_to? :stop_points || item.is_a?(Chouette::TimeTable)
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
  end

  # TODO: `def build_link[s]`
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

        unless item.is_a?(Calendar) || item.is_a?(Referential)
          if current_referential
            polymorph_url << current_referential
            polymorph_url << item.line if item.respond_to? :line
            polymorph_url << item.route.line if item.is_a?(Chouette::RoutingConstraintZone)
            polymorph_url << item if item.respond_to? :line_referential
            polymorph_url << item.stop_area if item.respond_to? :stop_area
            polymorph_url << item if item.respond_to? :stop_points || item.is_a?(Chouette::TimeTable)
          elsif item.respond_to? :referential
            polymorph_url << item.referential
          end
        else
          polymorph_url << item
        end

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
        elsif action == :archive
          unless item.archived?
            content_tag :li, link_to(t("actions.#{action}"), polymorph_url, method: :put)
          end
        elsif action == :unarchive
          if item.archived?
            content_tag :li, link_to(t("actions.#{action}"), polymorph_url, method: :put)
          end
        else
          content_tag :li, link_to(t("actions.#{action}"), polymorph_url)
        end
      end.join.html_safe
    end

    content_tag :div, trigger + menu, class: 'btn-group'

  end

  # TODO: clean up?
  def sortable_columns collection, key
      # #<ActiveRecord::Relation [#<Referential id: 4, name: "Referential Yanis Gaillard", slug: "referential_yanis_gaillard", created_at: "2017-05-02 12:37:38", updated_at: "2017-05-02 12:37:49", prefix: "c4nqg22nvt", projection_type: nil, time_zone: "Paris", bounds: nil, organisation_id: 1, geographical_bounds: nil, user_id: nil, user_name: nil, data_format: "neptune", line_referential_id: 1, stop_area_referential_id: 1, workbench_id: 1, archived_at: nil, created_from_id: nil, ready: true>, #<Referential id: 3, name: "Test Referential 2017.04.25", slug: "test_referential_20170425", created_at: "2017-04-25 10:08:49", updated_at: "2017-04-25 10:08:51", prefix: "test_referential_20170425", projection_type: "", time_zone: "Paris", bounds: "SRID=4326;POLYGON((-5.2 42.25,-5.2 51.1,8.23 51.1,...", organisation_id: 1, geographical_bounds: nil, user_id: 1, user_name: "Wing Teddy", data_format: "neptune", line_referential_id: 1, stop_area_referential_id: 1, workbench_id: 1, archived_at: nil, created_from_id: nil, ready: true>]>
    # (byebug) collection.model
    # Referential(id: integer, name: string, slug: string, created_at: datetime, updated_at: datetime, prefix: string, projection_type: string, time_zone: string, bounds: string, organisation_id: integer, geographical_bounds: text, user_id: integer, user_name: string, data_format: string, line_referential_id: integer, stop_area_referential_id: integer, workbench_id: integer, archived_at: datetime, created_from_id: integer, ready: boolean)
    # params = {"controller"=>"workbenches", "action"=>"show", "id"=>"1", "q"=>{"archived_at_not_null"=>"1", "archived_at_null"=>"1"}}
    direction = (key.to_s == params[:sort] && params[:direction] == 'desc') ? 'asc' : 'desc'

    link_to(params.merge({direction: direction, sort: key})) do
      pic1 = content_tag :span, '', class: "fa fa-sort-asc #{(direction == 'desc') ? 'active' : ''}"
      pic2 = content_tag :span, '', class: "fa fa-sort-desc #{(direction == 'asc') ? 'active' : ''}"

      pics = content_tag :span, pic1 + pic2, class: 'orderers'
      # TODO: figure out a way to maybe explicitise the dynamicness of getting the model type from the `collection`.
      # TODO: rename `pics` to something like `icons` or arrow icons or some such

      (column_header_label(collection.model, key) + pics).html_safe
    end
  end

  def column_header_label(model, field)
    # Transform `Chouette::Line` into "line"
    model_key = model.to_s.demodulize.underscore

    I18n.t("activerecord.attributes.#{model_key}.#{field}")
  end

  def checkbox(id_name:, value:)
    content_tag :div, '', class: 'checkbox' do
      check_box_tag(id_name, value).concat(
        content_tag(:label, '', for: id_name)
      )
    end
  end
end
