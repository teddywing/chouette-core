module TableBuilderHelper
  class Column
    attr_reader :key, :name, :attribute, :sortable

    def initialize(key: nil, name: '', attribute:, sortable: true)
      if key.nil? && name.empty?
        raise ColumnMustHaveKeyOrNameError
      end

      # TODO: Make a similar _ && _ for either `attribute`, which should be a
      # string attribute, and another param, which should represent a proc.
      # Then maybe have an `#attribute` method that returns either the string
      # or the result of the proc

      @key = key
      @name = name
      @attribute = attribute
      @sortable = sortable
    end
  end

  class ColumnMustHaveKeyOrNameError < StandardError; end


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

        columns.map do |column|
          hcont << content_tag(:th, build_column_header(
            column,
            collection.model,
            params,
            params[:sort],
            params[:direction]
          ))
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
      collection.map do |item|

        content_tag :tr do
          bcont = []

          if selectable
            bcont << content_tag(
              :td,
              checkbox(id_name: item.try(:id), value: item.try(:id))
            )
          end

          columns.map do |column|
            value =
              if Proc === column.attribute
                column.attribute.call(item)
              else
                item.try(column.attribute)
              end

            if column.attribute == 'name' || column.attribute == 'comment'
              # Build a link to the `item`
              polymorph_url = polymorphic_url_parts(item)
              bcont << content_tag(:td, link_to(value, polymorph_url), title: 'Voir')
            else
              bcont << content_tag(:td, value)
            end
          end

          if links.any?
            bcont << content_tag(
              :td,
              build_links(item, links),
              class: 'actions'
            )
          end

          bcont.join.html_safe
        end
      end.join.html_safe
    end
  end

  def build_links(item, actions)
    trigger = content_tag :div, class: 'btn dropdown-toggle', data: { toggle: 'dropdown' } do
      content_tag :span, '', class: 'fa fa-cog'
    end

    menu = content_tag :ul, class: 'dropdown-menu' do
      actions.map do |action|
        polymorph_url = []

        unless [:show, :delete].include? action
          polymorph_url << action
        end

        polymorph_url += polymorphic_url_parts(item)

        if action == :delete
          if policy(item).present?
            if policy(item).destroy?
              # TODO: This tag is exactly the same as the one below it
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

  def build_column_header(
    column,
    collection_model,
    params,
    sort_on,
    sort_direction
  )
    return column.name if !column.sortable

    direction =
      if column.key.to_s == sort_on && sort_direction == 'desc'
        'asc'
      else
        'desc'
      end

    link_to(params.merge({direction: direction, sort: column.key})) do
      arrow_up = content_tag(
        :span,
        '',
        class: "fa fa-sort-asc #{direction == 'desc' ? 'active' : ''}"
      )
      arrow_down = content_tag(
        :span,
        '',
        class: "fa fa-sort-desc #{direction == 'asc' ? 'active' : ''}"
      )

      arrow_icons = content_tag :span, arrow_up + arrow_down, class: 'orderers'

      (
        column_header_label(collection_model, column.key) +
        arrow_icons
      ).html_safe
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

  def polymorphic_url_parts(item)
    polymorph_url = []

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

    polymorph_url
  end
end
