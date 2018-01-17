class CompanyDecorator < AF83::Decorator
  decorates Chouette::Company

  action_link on: :index, primary: :index, policy: :create do |l|
    l.content { h.t('companies.actions.new') }
    l.href    { [:new, context[:referential], :company] }
  end

  with_instance_decorator do |instance_decorator|
    instance_decorator.action_link primary: :index do |l|
      l.content { h.t('actions.show') }
      l.href { [object] }
    end

    instance_decorator.action_link primary: %i(show index) do |l|
      l.content {|l| l.action == "show" ? h.t('actions.edit') : h.t('companies.actions.edit') }
      l.href {
        h.edit_line_referential_company_path(
          context[:referential],
          object
        )
      }
    end

    instance_decorator.action_link policy: :destroy, footer: true, secondary: :show  do |l|
      l.content { h.destroy_link_content('companies.actions.destroy') }
      l.href {
        h.edit_line_referential_company_path(
          context[:referential],
          object
        )
      }
      l.method { :delete }
      l.data {{ confirm: h.t('companies.actions.destroy_confirm') }}
    end
  end
end
