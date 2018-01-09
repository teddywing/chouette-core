class ImportDecorator < Draper::Decorator
  decorates Import

  delegate_all

  def import_status_css_class
    cls =''
    cls = 'overheaded-success' if object.status == 'successful'
    cls = 'overheaded-warning' if object.status == 'warning'
    cls = 'overheaded-danger' if %w[failed aborted canceled].include? object.status
    cls
  end

  def action_links
    policy = h.policy(object)
    links = []

    links << Link.new(
      content: h.t('imports.actions.download'),
      href: object.file.url
    )

    if policy.destroy?
      links << Link.new(
        content: h.destroy_link_content,
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
