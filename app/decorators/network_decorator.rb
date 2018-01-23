class NetworkDecorator < AF83::Decorator
  decorates Chouette::Network

  # Action links require:
  #   context: {
  #     line_referential: ,
  #   }

  create_action_link do |l|
    l.content t('networks.actions.new')
    l.href { h.new_line_referential_network_path(context[:line_referential]) }
    l.class 'btn btn-primary'
  end

  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link do |l|
      l.href do
        h.line_referential_network_path(context[:line_referential], object)
      end
    end

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
      l.content h.destroy_link_content('networks.actions.destroy')
      l.href do
        h.line_referential_network_path(
          context[:line_referential],
          object
        )
      end
      l.data confirm: h.t('networks.actions.destroy_confirm')
    end
  end
end
