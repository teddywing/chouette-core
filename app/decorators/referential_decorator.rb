class ReferentialDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = [
      Link.new(
        name: h.t('time_tables.index.title'),
        href: h.referential_time_tables_path(object)
      )
    ]

    if h.policy(object).clone?
      links << Link.new(
        name: h.t('actions.clone'),
        href: h.new_referential_path(from: object.id)
      )
    end

    if h.policy(object).edit?
      # TODO: Handle buttons in the header and don't show them in the gear menu
      # button.btn.btn-primary type='button' data-toggle='modal' data-target='#purgeModal' Purger

      if object.archived?
        links << Link.new(
          name: h.t('actions.unarchive'),
          href: h.unarchive_referential_path(object.id),
          method: :put
        )
      else
        links << Link.new(
          name: h.t('actions.archive'),
          href: h.archive_referential_path(object.id),
          method: :put
        )
      end
    end

    if h.policy(object).destroy?
      links << Link.new(
        href: h.referential_path(object),
        method: :delete,
        data: { confirm: h.t('referentials.actions.destroy_confirm') },
        content: h.destroy_link_content
      )
    end

    links
  end
end
