require 'table_builder_helper/url'

module TableBuilderHelper
  class CustomLinks
    ACTIONS_TO_HTTP_METHODS = {
      delete: :delete,
      archive: :put,
      unarchive: :put
    }

    attr_reader :actions, :object, :user_context, :referential

    def initialize(object, user_context, actions, referential = nil)
      @object       = object
      @user_context = user_context
      @actions      = actions
      @referential  = referential
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

      polymorph_url += URL.polymorphic_url_parts(object, referential)
    end

    def method_for_action(action)
      ACTIONS_TO_HTTP_METHODS[action]
    end

    def authorized_actions
      actions.select(&policy.method(:authorizes_action?))
    end

    private

    def policy
      @__policy__ ||= Pundit.policy(user_context, object)
    end
  end
end
