class LineDecorator < AF83::Decorator
  decorates Chouette::Line

  delegate_all

  ### primary (and secondary) can be
  ### - a single action
  ### - an array of actions
  ### - a boolean

  action_link primary: :index do |l|
    l.content h.t('lines.actions.show')
    l.href   { [context[:line_referential], object] }
  end

  action_link do |l|
    l.content h.t('lines.actions.show_network')
    l.href   { [context[:line_referential], object.network] }
  end

  action_link do |l|
    l.content  { h.t('lines.actions.show_company') }
    l.href     { [context[:line_referential], object.company] }
    l.disabled { object.company.nil? }
  end

  can_edit_line = ->(){ h.policy(Chouette::Line).create? && context[:line_referential].organisations.include?(context[:current_organisation]) }

  with_condition can_edit_line do
    action_link on: :index do |l|
      l.content { h.t('lines.actions.new') }
      l.href    { h.new_line_referential_line_path(context[:line_referential]) }
    end

    action_link on: %i(index show), primary: :show do |l|
      l.content { h.t('lines.actions.edit') }
      l.href    { h.edit_line_referential_line_path(context[:line_referential], object.id) }
    end
  end

  ### the option :policy will automatically check for the corresponding method
  ### on the object's policy

  action_link policy: :deactivate, secondary: true do |l|
    l.content  { h.deactivate_link_content('lines.actions.deactivate') }
    l.href     { h.deactivate_line_referential_line_path(context[:line_referential], object) }
    l.method   :put
    l.data     confirm: h.t('lines.actions.deactivate_confirm')
    l.extra_class "delete-action"
  end

  action_link policy: :activate, secondary: true do |l|
    l.content  { h.activate_link_content('lines.actions.activate') }
    l.href     { h.activate_line_referential_line_path(context[:line_referential], object) }
    l.method   :put
    l.data     confirm: h.t('lines.actions.activate_confirm')
    l.extra_class "delete-action"
  end

  action_link policy: :destroy do |l|
    l.content  { h.destroy_link_content('lines.actions.destroy') }
    l.href     { h.line_referential_line_path(context[:line_referential], object) }
    l.method   :delete
    l.data     confirm: h.t('lines.actions.destroy_confirm')
    l.extra_class "delete-action"
  end
end
