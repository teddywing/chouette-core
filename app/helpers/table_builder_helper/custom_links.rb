require 'table_builder_helper/url'

module TableBuilderHelper
  class CustomLinks
    ACTIONS_TO_HTTP_METHODS = {
      delete: :delete,
      archive: :put,
      unarchive: :put
    }

    attr_reader :actions, :object, :user_context

    def initialize(object, user_context, actions)
      @object       = object
      @user_context = user_context
      @actions      = actions
    end

    def links
      authorized_actions.map do |action|
        Link.new(
          content: I18n.t("actions.#{action}"),
          href: polymorphic_url(action),
          method: method_for_action(action)
        )
      end
    end

    def polymorphic_url(action)
      polymorph_url = []

      unless [:show, :delete].include?(action)
        polymorph_url << action
      end

      polymorph_url += URL.polymorphic_url_parts(@object)
    end

    def method_for_action(action)
      ACTIONS_TO_HTTP_METHODS[action]
    end

    def authorized_actions
      @actions.select(&method(:action_authorized?))
    end
    def action_authorized?(action)
      # TODO: Remove this guard when all resources have policies associated to them
      return true unless policy
      policy.public_send("#{action}?")
    rescue NoMethodError
      # TODO: When all action permissions are implemented for all policies remove this rescue clause
      action_is_allowed_regardless_of_policy(action)
    end

    private

    def action_is_allowed_regardless_of_policy(action)
      ![:delete, :edit, :archive, :unarchive, :duplicate, :actualize].include?(action)
    end

    def policy
      @__policy__ ||= Pundit.policy(user_context, object)
    end
  end
end
