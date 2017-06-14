require 'table_builder_helper/url'

module TableBuilderHelper
  class CustomLinks
    ACTIONS_TO_HTTP_METHODS = {
      delete: :delete,
      archive: :put,
      unarchive: :put
    }

    def initialize(obj, user_context, actions)
      @obj = obj
      @user_context = user_context
      @actions = actions
    end

    def links
      actions_after_policy_check.map do |action|
        Link.new(
          name: I18n.t("actions.#{action}"),
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

      polymorph_url += URL.polymorphic_url_parts(@obj)
    end

    def method_for_action(action)
      ACTIONS_TO_HTTP_METHODS[action] || :get
    end

    def actions_after_policy_check
      @actions.select do |action|
        (action == :delete &&
            Pundit.policy(@user_context, @obj).present? &&
            Pundit.policy(@user_context, @obj).destroy?) ||
          (action == :delete &&
            !Pundit.policy(@user_context, @obj).present?) ||
          (action == :edit &&
            Pundit.policy(@user_context, @obj).present? &&
            Pundit.policy(@user_context, @obj).update?) ||
          (action == :edit &&
            !Pundit.policy(@user_context, @obj).present?) ||
          (action == :archive && !@obj.archived?) ||
          (action == :unarchive && @obj.archived?) ||
          (![:delete, :edit, :archive, :unarchive].include?(action))
      end
    end
  end
end
