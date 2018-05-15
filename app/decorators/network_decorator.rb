class NetworkDecorator < AF83::Decorator
  decorates Chouette::Network

  set_scope { context[:line_referential] }
  # Action links require:
  #   context: {
  #     line_referential: ,
  #   }

  create_action_link do |l|
    l.content t('networks.actions.new')
  end

  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link

    instance_decorator.action_link secondary: true, policy: :edit do |l|
      l.content t('networks.actions.edit')
      l.href do
        h.edit_line_referential_network_path(
          context[:line_referential],
          object
        )
      end
    end

    instance_decorator.destroy_action_link do |l|
      l.content h.t('networks.actions.destroy')
      l.data confirm: h.t('networks.actions.destroy_confirm')
    end
  end
end
