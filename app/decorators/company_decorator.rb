class CompanyDecorator < AF83::Decorator
  decorates Chouette::Company

  create_action_link do |l|
    l.content { h.t('companies.actions.new') }
    l.href    { [:new, context[:referential], :company] }
  end

  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link do |l|
      l.href { [context[:referential], object] }
    end

    instance_decorator.edit_action_link do |l|
      l.content {|l| l.action == "show" ? h.t('actions.edit') : h.t('companies.actions.edit') }
      l.href {
        h.edit_line_referential_company_path(
          context[:referential],
          object
        )
      }
    end

    instance_decorator.destroy_action_link do |l|
      l.content { h.destroy_link_content('companies.actions.destroy') }
      l.href {
        h.edit_line_referential_company_path(
          context[:referential],
          object
        )
      }
      l.data {{ confirm: h.t('companies.actions.destroy_confirm') }}
    end
  end
end
