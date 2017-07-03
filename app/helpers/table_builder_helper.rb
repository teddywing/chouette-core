require 'table_builder_helper/column'
require 'table_builder_helper/custom_links'
require 'table_builder_helper/url'

# table_builder_2
# A Rails helper that constructs an HTML table from a collection of objects. It
# receives the collection and an array of columns that get transformed into
# `<td>`s. A column of checkboxes can be added to the left side of the table
# for multiple selection. Columns are sortable by default, but sorting can be
# disabled either at the table level or at the column level. An optional
# `links` argument takes a set of symbols corresponding to controller actions
# that should be inserted in a gear menu next to each row in the table. That
# menu will also be populated with links defined in `collection#action_links`,
# a list of `Link` objects defined in a decorator for the given object.
#
# Depends on `params` and `current_referential`.
#
# Example:
#   table_builder_2(
#     @companies,
#     [
#       TableBuilderHelper::Column.new(
#         name: 'ID Codif',
#         attribute: Proc.new { |n| n.try(:objectid).try(:local_id) },
#         sortable: false
#       ),
#       TableBuilderHelper::Column.new(
#         key: :name,
#         attribute: 'name'
#       ),
#       TableBuilderHelper::Column.new(
#         key: :phone,
#         attribute: 'phone'
#       ),
#       TableBuilderHelper::Column.new(
#         key: :email,
#         attribute: 'email'
#       ),
#       TableBuilderHelper::Column.new(
#         key: :url,
#         attribute: 'url'
#       ),
#     ],
#     links: [:show, :edit],
#     cls: 'table has-search'
#   )
module TableBuilderHelper
  # TODO: rename this after migration from `table_builder`
  def table_builder_2(
    # An `ActiveRecord::Relation`, wrapped in a decorator to provide a list of
    # `Link` objects via an `#action_links` method
    collection,

    # An array of `TableBuilderHelper::Column`s
    columns,

    # When false, no columns will be sortable
    sortable: true,

    # When true, adds a column of checkboxes to the left side of the table
    selectable: false,

    # A set of controller actions that will be added as links to the top of the
    # gear menu
    links: [],

    # A CSS class to apply to the <table>
    cls: ''
  )
    links = links_for_gear_menu(links, 
    content_tag :table,
      thead(collection, columns, sortable, selectable, links.any?) +
        tbody(collection, columns, selectable, links),
      class: cls
  end

  private

  def thead(collection, columns, sortable, selectable, has_links)
    content_tag :thead do
      content_tag :tr do
        hcont = []

        if selectable
          hcont << content_tag(:th, checkbox(id_name: '0', value: 'all'))
        end

        columns.each do |column|
          hcont << content_tag(:th, build_column_header(
            column,
            sortable,
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

          columns.each do |column|
            value = column.value(item)

            if column_is_linkable?(column)
              # Build a link to the `item`
              polymorph_url = URL.polymorphic_url_parts(item)
              bcont << content_tag(:td, link_to(value, polymorph_url), title: 'Voir')
            else
              bcont << content_tag(:td, value)
            end
          end

          bcont << build_links(item, links)

          bcont.join.html_safe
        end
      end.join.html_safe
    end
  end

  def build_links(item, links)
    trigger = content_tag(
      :div,
      class: 'btn dropdown-toggle',
      data: { toggle: 'dropdown' }
    ) do
      content_tag :span, '', class: 'fa fa-cog'
    end

    # return if links.empty?

    menu = content_tag :ul, class: 'dropdown-menu' do
      links.map do |link|
        gear_menu_link(link)
      end.join.html_safe
    end

    content_tag(
      :td,
      content_tag(:div, trigger + menu, class: 'btn-group'),
      class: 'actions'
    )
  end

  def build_column_header(
    column,
    table_is_sortable,
    collection_model,
    params,
    sort_on,
    sort_direction
  )
    if !table_is_sortable
      return column.header_label(collection_model)
    end

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
        column.header_label(collection_model) +
        arrow_icons
      ).html_safe
    end
  end

  def checkbox(id_name:, value:)
    content_tag :div, '', class: 'checkbox' do
      check_box_tag(id_name, value).concat(
        content_tag(:label, '', for: id_name)
      )
    end
  end

  def column_is_linkable?(column)
    column.attribute == 'name' || column.attribute == 'comment'
  end

  def links_for_gear_menu(links, obj)
    CustomLinks.new(item, pundit_user, links).links +
      (item.try(:action_links) || []).select { |link| link.is_a?(Link) }
  end

  def gear_menu_link(link)
    content_tag(
      :li,
      link_to(
        link.href,
        method: link.method,
        data: link.data
      ) do
        link.content
      end,
      class: ('delete-action' if link.method == :delete)
    )
  end
end
