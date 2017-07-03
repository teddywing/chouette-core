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

      polymorph_url += URL.polymorphic_url_parts(@obj)
    end

    def method_for_action(action)
      ACTIONS_TO_HTTP_METHODS[action]
    end

    def actions_after_policy_check
      @actions.select do |action|
        # TODO: My idea would be to push authorization logic into policies
        #       Eventually the code should look like:
        #       select do |action|
        #         Pundit.policy(@user_context, @obj).send("#{action}?")
        #       end
        #       This puts the responsability where it belongs to and allows
        #       for easy and fast unit testing of the BL, always a goos sign.

        # Has policy and can destroy
        (action == :delete &&
            Pundit.policy(@user_context, @obj).present? &&
            Pundit.policy(@user_context, @obj).destroy?) ||

          # Doesn't have policy
          (action == :delete &&
            !Pundit.policy(@user_context, @obj).present?) ||

          # Has policy and can update
          (action == :edit &&
            Pundit.policy(@user_context, @obj).present? &&
            Pundit.policy(@user_context, @obj).update?) ||

          # Doesn't have policy
          (action == :edit &&
            !Pundit.policy(@user_context, @obj).present?) ||

          # Object isn't archived
          (action == :archive && !@obj.archived?) ||

          # Object is archived
          (action == :unarchive && @obj.archived?) ||

          !Pundit.policy(@user_context, @obj).respond_to?("#{action}?") ||
          Pundit.policy(@user_context, @obj).public_send("#{action}?") ||
            

          action_is_allowed_regardless_of_policy(action)
      end
    end

    private

    def action_is_allowed_regardless_of_policy(action)
      ![:delete, :edit, :archive, :unarchive, :duplicate, :actualize].include?(action)
    end
  end
end
