class StopAreaDecorator < Draper::Decorator
  decorates Chouette::StopArea

  delegate_all

  def action_links
    links = []

    if h.policy(Chouette::StopArea).new?
      links << Link.new(
        content: h.t('stop_areas.actions.new'),
        href: h.new_stop_area_referential_stop_area_path(
          object.stop_area_referential
        )
      )
    end

    if h.policy(object).update?
      links << Link.new(
        content: h.t('stop_areas.actions.edit'),
        href: h.edit_stop_area_referential_stop_area_path(
          object.stop_area_referential,
          object
        )
      )
    end

    if h.policy(object).destroy?
      links << Link.new(
        content: h.destroy_link_content('stop_areas.actions.destroy'),
        href: h.stop_area_referential_stop_area_path(
          object.stop_area_referential,
          object
        ),
        method: :delete,
        data: { confirm: t('stop_areas.actions.destroy_confirm') }
      )
    end

    links
  end
end
