class PurchaseWindowDecorator < Draper::Decorator
  decorates Chouette::PurchaseWindow
  delegate_all

  def action_links
    policy = h.policy(object)
    links = []

    if policy.update?
      links << Link.new(
        content: I18n.t('actions.edit'),
        href: h.edit_referential_purchase_window_path(context[:referential].id, object)
      )
    end

    if policy.destroy?
      links << Link.new(
        content: I18n.t('actions.destroy'),
        href: h.referential_purchase_window_path(context[:referential].id, object),
        method: :delete,
        data: { confirm: h.t('purchase_window.actions.destroy_confirm') }
      )
    end

    links
  end
end