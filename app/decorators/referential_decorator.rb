class ReferentialDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = [
      Link.new(
        content: h.t('time_tables.index.title'),
        href: h.referential_time_tables_path(object)
      )
    ]

    if h.policy(object).clone?
      links << Link.new(
        content: h.t('actions.clone'),
        href: h.new_referential_path(from: object.id)
      )
    end

    if h.policy(object).edit?

      if object.archived?
        links << Link.new(
          content: h.t('actions.unarchive'),
          href: h.unarchive_referential_path(object.id),
          method: :put
        )
      else
        links << HTMLElement.new(
          :button,
          'Purger',
          type: 'button',
          data: {
            toggle: 'modal',
            target: '#purgeModal'
          }
        )
        links << Link.new(
          content: h.t('actions.archive'),
          href: h.archive_referential_path(object.id),
          method: :put
        )
      end
    end

    if h.policy(object).destroy? && !object.archived?
      links << Link.new(
        content: h.destroy_link_content,
        href: h.referential_path(object),
        method: :delete,
        data: { confirm: h.t('referentials.actions.destroy_confirm') }
      )
    end

    links
  end
end
