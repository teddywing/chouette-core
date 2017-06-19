# TODO: Add @referential to context
class Chouette::TimeTableDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []

    if object.calendar
      links << Link.new(
        content: h.t('actions.actualize'),
        href: h.actualize_referential_time_table_path(@referential, object),
        method: :post
      )
    end

    links << Link.new(
      content: h.t('actions.combine'),
      href: h.new_referential_time_table_time_table_combination_path(
        @referential,
        object
      )
    )

    if h.policy(object).duplicate?
      links << Link.new(
        content: h.t('actions.duplicate'),
        href: h.duplicate_referential_time_table_path(@referential, object)
      )
    end

    if h.policy(object).destroy?
      Link.new(
        content: h.destroy_link_content,
        href: h.referential_time_table_path(@referential, object),
        method: :delete,
        data: { confirm: h.t('time_tables.actions.destroy_confirm') }
      )
    end

    links
  end
end
