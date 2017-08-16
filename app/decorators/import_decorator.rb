class ImportDecorator < Draper::Decorator
  decorates Import

  delegate_all

  def action_links
    links = []

    links << Link.new(
      content: h.t('imports.actions.show'),
      href: h.workbench_import_path(
        context[:workbench],
        object
      )
    )

    links << Link.new(
      content: "Téléch. fichier source",
      href: object.file.url
    )

    # if h.policy(object).destroy?
    links << Link.new(
      content: h.destroy_link_content,
      href: h.workbench_import_path(
        context[:workbench],
        object
      ),
      method: :delete,
      data: { confirm: h.t('imports.actions.destroy_confirm') }
    )

    links
  end

end
