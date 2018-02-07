class ReferentialNetworkDecorator < AF83::Decorator
  decorates Chouette::Network

  # Action links require:
  #   context: {
  #     referential: ,
  #   }

  create_action_link do |l|
    l.content t('networks.actions.new')
    l.href { h.new_referential_network_path(context[:referential]) }
  end

  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link do |l|
      l.href { h.referential_network_path(context[:referential], object) }
    end

    instance_decorator.edit_action_link do |l|
      l.content t('networks.actions.edit')
      l.href do
        h.edit_referential_network_path(
          context[:referential],
          object
        )
      end
    end

    instance_decorator.destroy_action_link do |l|
      l.content h.destroy_link_content('networks.actions.destroy')
      l.href do
        h.referential_network_path(
          context[:referential],
          object
        )
      end
      l.data confirm: h.t('networks.actions.destroy_confirm')
    end
  end
end