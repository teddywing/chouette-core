class StopAreaDecorator < Draper::Decorator
  decorates Chouette::StopArea

  delegate_all

  def common_action_links(stop_area = nil)
    top_links, bottom_links = [], []
    stop_area ||= object

    if h.policy(stop_area).update?
      top_links << Link.new(
        content: h.t('stop_areas.actions.edit'),
        href: h.edit_stop_area_referential_stop_area_path(
          stop_area.stop_area_referential,
          stop_area
        )
      )
    end

    if h.policy(stop_area).destroy?
      bottom_links << Link.new(
        content: h.destroy_link_content('stop_areas.actions.destroy'),
        href: h.stop_area_referential_stop_area_path(
          stop_area.stop_area_referential,
          stop_area
        ),
        method: :delete,
        data: { confirm: t('stop_areas.actions.destroy_confirm') }
      )
    end

    [top_links, bottom_links]
  end

  def action_links(stop_area = nil)
    stop_area ||= object
    top_links, bottom_links = common_action_links(stop_area)
    links = []

    if h.policy(object).deactivate?
      links << Link.new(
        content: h.deactivate_link_content('stop_areas.actions.deactivate'),
        href: h.deactivate_stop_area_referential_stop_area_path(stop_area.stop_area_referential, object),
        method: :put,
        data: {confirm: h.t('stop_areas.actions.deactivate_confirm')},
        extra_class: "delete-action"
      )
    end

    if h.policy(object).activate?
      links << Link.new(
        content: h.activate_link_content('stop_areas.actions.activate'),
        href: h.activate_stop_area_referential_stop_area_path(stop_area.stop_area_referential, object),
        method: :put,
        data: {confirm: h.t('stop_areas.actions.activate_confirm')},
        extra_class: "delete-action"
      )
    end

    top_links + links + bottom_links
  end

  def waiting_time_text
    return '-' if [nil, 0].include? waiting_time
    h.t('stop_areas.waiting_time_format', value: waiting_time)
  end

end
