class ImportDecorator < Draper::Decorator
  decorates Import

  delegate_all

  def action_links
    links = []

    if h.policy(object).destroy?
      links << Link.new(
        content: t('actions.destroy'),
        href: h.workbench_import_path(
          context[:workbench],
          object
        ),
        method: :delete,
        data: { confirm: h.t('imports.actions.destroy_confirm') }
      )
    end

    links
  end

end
