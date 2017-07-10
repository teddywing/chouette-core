class CompanyDecorator < Draper::Decorator
  decorates Chouette::Company

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def linecount
    object.lines.count
  end

  # Requires:
  #   context: {
  #     line_referential:
  #   }
  def action_links
    links = []

    if h.policy(Chouette::Company).create?
      require 'pry'
      binding.pry
      links << Link.new(
        content: h.t('companies.actions.new'),
        href: h.new_line_referential_company_path(context[:line_referential])
      )
    end

    if h.policy(object).update?
      links << Link.new(
        content: h.t('companies.actions.edit'),
        href: h.edit_line_referential_company_path(
          context[:line_referential],
          object
        )
      )
    end

    if h.policy(object).destroy?
      links << Link.new(
        content: t('companies.actions.destroy'),
        href: h.line_referential_company_path(
          context[:line_referential],
          object
        ),
        method: :delete,
        data: { confirm: h.t('companies.actions.destroy_confirm') }
      )
    end

    links
  end

end
