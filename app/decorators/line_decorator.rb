class LineDecorator < AF83::Decorator
  decorates Chouette::Line

  create_action_link do |l|
    l.content t('lines.actions.new')
    l.href    { h.new_line_referential_line_path(context[:line_referential]) }
  end

  with_instance_decorator do |instance_decorator|
    ### primary (and secondary) can be
    ### - a single action
    ### - an array of actions
    ### - a boolean

    instance_decorator.show_action_link do |l|
      l.content t('lines.actions.show')
      l.href   { [context[:line_referential], object] }
    end

    instance_decorator.action_link secondary: :show do |l|
      l.content t('lines.actions.show_network')
      l.href   { [context[:line_referential], object.network] }
      l.disabled { object.network.nil? }
    end

    instance_decorator.action_link secondary: :show do |l|
      l.content  t('lines.actions.show_company')
      l.href     { [context[:line_referential], object.company] }
      l.disabled { object.company.nil? }
    end

    can_edit_line = ->(){ h.policy(Chouette::Line).create? && context[:line_referential].organisations.include?(context[:current_organisation]) }

    instance_decorator.with_condition can_edit_line do
      edit_action_link do |l|
        l.content {|l| l.primary? ? h.t('actions.edit') : h.t('lines.actions.edit') }
        l.href    { h.edit_line_referential_line_path(context[:line_referential], object.id) }
      end

      action_link on: :index, secondary: :index do |l|
        l.content t('lines.actions.new')
        l.href    { h.new_line_referential_line_path(context[:line_referential]) }
      end
    end

    ### the option :policy will automatically check for the corresponding method
    ### on the object's policy

    instance_decorator.action_link policy: :deactivate, secondary: :show, footer: :index do |l|
      l.content  { h.deactivate_link_content('lines.actions.deactivate') }
      l.href     { h.deactivate_line_referential_line_path(context[:line_referential], object) }
      l.method   :put
      l.data     confirm: h.t('lines.actions.deactivate_confirm')
      l.add_class "delete-action"
    end

    instance_decorator.action_link policy: :activate, secondary: :show, footer: :index do |l|
      l.content  { h.activate_link_content('lines.actions.activate') }
      l.href     { h.activate_line_referential_line_path(context[:line_referential], object) }
      l.method   :put
      l.data     confirm: h.t('lines.actions.activate_confirm')
      l.add_class "delete-action"
    end

    instance_decorator.destroy_action_link do |l|
      l.content  { h.destroy_link_content('lines.actions.destroy') }
      l.href     { h.line_referential_line_path(context[:line_referential], object) }
      l.data     confirm: h.t('lines.actions.destroy_confirm')
      l.add_class "delete-action"
    end
  end
end
