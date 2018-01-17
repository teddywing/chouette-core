class ReferentialDecorator < AF83::Decorator
  decorates Referential

  with_instance_decorator do |instance_decorator|
    instance_decorator.action_link primary: %i(show index) do |l|
      l.content { h.t('actions.edit') }
      l.href { [object] }
    end

    instance_decorator.action_link feature: :referential_vehicle_journeys, secondary: :show do |l|
      l.content t('referential_vehicle_journeys.index.title')
      l.href { h.referential_vehicle_journeys_path(object) }
    end

    instance_decorator.action_link feature: :purchase_windows, secondary: :show do |l|
      l.content t('purchase_windows.index.title')
      l.href { h.referential_purchase_windows_path(object) }
    end

    instance_decorator.action_link secondary: :show do |l|
      l.content t('time_tables.index.title')
      l.href { h.referential_time_tables_path(object) }
    end

    instance_decorator.action_link policy: :clone, secondary: :show do |l|
      l.content t('actions.clone')
      l.href { h.new_referential_path(from: object.id, current_workbench_id: context[:current_workbench_id]) }
    end

    instance_decorator.action_link policy: :validate, secondary: :show do |l|
      l.content t('actions.validate')
      l.href { h.referential_select_compliance_control_set_path(object.id) }
    end

    instance_decorator.action_link policy: :archive, secondary: :show do |l|
      l.content t('actions.archive')
      l.href { h.archive_referential_path(object.id) }
      l.method :put
    end

    instance_decorator.action_link policy: :unarchive, secondary: :show do |l|
      l.content t('actions.unarchive')
      l.href { h.unarchive_referential_path(object.id) }
      l.method :put
    end

    instance_decorator.action_link policy: :edit, secondary: :show do |l|
      l.content 'Purger'
      l.href '#'
      l.type 'button'
      l.data {{
        toggle: 'modal',
        target: '#purgeModal'
      }}
    end

    instance_decorator.action_link policy: :destroy, footer: true, secondary: :show  do |l|
      l.content { h.destroy_link_content }
      l.href { h.referential_path(object) }
      l.method { :delete }
      l.data {{ confirm: h.t('referentials.actions.destroy_confirm') }}
    end

  end
  # def action_links
  #   policy = h.policy(object)
  #   links = []
  #
  #   if policy.edit?
  #     links << HTMLElement.new(
  #       :button,
  #       'Purger',
  #       type: 'button',
  #       data: {
  #         toggle: 'modal',
  #         target: '#purgeModal'
  #       }
  #     )
  #   end
  #
  #   if policy.destroy?
  #     links << Link.new(
  #       content: h.destroy_link_content,
  #       href: h.referential_path(object),
  #       method: :delete,
  #       data: { confirm: h.t('referentials.actions.destroy_confirm') }
  #     )
  #   end

    # links
  # end
  #
  # private
  #
  # # TODO move to a base Decorator (ApplicationDecorator)
  # def has_feature?(*features)
  #   h.has_feature?(*features) rescue false
  # end

end
