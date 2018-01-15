class AF83::Decorator < Draper::Decorator
  def self.action_link args={}
    args[:if] = @_condition if args[:if].nil?

    options, link_options = parse_options args

    link = Link.new(link_options)
    yield link if block_given?
    raise IncompleteLinkDefinition.new(link.errors) unless link.complete?

    weight = options[:weight] || 1
    @_action_links ||= []
    @_action_links[weight] ||= []
    @_action_links[weight] << link
  end

  def self.with_condition condition, &block
    @_condition = condition
    instance_eval &block
    @_condition = nil
  end

  def self.action_links action
    (@_action_links || []).flatten.compact.select{|l| l.for_action?(action)}
  end

  def action_links action=:index, opts={}
    links = ActionLinks.new links: self.class.action_links(action), context: self, action: action
    group = opts[:group]
    links = links.for_group opts[:group]
    links
  end

  def primary_links action=:index
    action_links(action, group: :primary)
  end

  def secondary_links action=:index
    action_links(action, group: :secondary)
  end

  def check_policy policy
    _object = policy.to_s == "create" ? object.class : object
    method = "#{policy}?"
    h.policy(_object).send(method)
  end

  private
  def self.parse_options args
    options = {}
    %i(weight primary secondary footer on action actions policy if groups group).each do |k|
      options[k] = args.delete(k) if args.has_key?(k)
    end
    link_options = args.dup

    actions = options.delete :actions
    actions ||= options.delete :on
    actions ||= [options.delete(:action)]
    actions = [actions] unless actions.is_a?(Array)
    link_options[:_actions] = actions.compact

    link_options[:_groups] = options.delete(:groups)
    link_options[:_groups] ||= {}
    if single_group = options.delete(:group)
      if(single_group.is_a?(Symbol) || single_group.is_a?(String))
        link_options[:_groups][single_group] = true
      else
        link_options[:_groups].update single_group
      end
    end
    link_options[:_groups][:primary] ||= options.delete :primary
    link_options[:_groups][:secondary] ||= options.delete :secondary
    link_options[:_groups][:footer] ||= options.delete :footer

    link_options[:_if] = options.delete(:if)
    link_options[:_policy] = options.delete(:policy)
    [options, link_options]
  end

  class ActionLinks
    attr_reader :options

    def initialize opts
      @options = opts.deep_dup
    end

    def for_group group
      returning_a_copy do
        @options[:groups] = [group] if group.present?
      end
    end

    def for_groups groups
      returning_a_copy do
        @options[:groups] = groups if groups.present?
      end
    end

    def primary
      for_group :primary
    end

    def secondary
      for_group :secondary
    end

    def resolve
      out = @options[:links].map{|l| l.bind_to_context(@options[:context])}.select{|l| l.enabled?}
      if @options[:groups].present?
        out = out.select do |l|
          @options[:groups].any? do |g|
            l.in_group_for_action?(@options[:action], g)
          end
        end
      end
      out
    end

    def grouped_by *groups
      add_footer = groups.include?(:footer)
      groups -= [:footer]
      out = HashWithIndifferentAccess[*groups.map{|g| [g, []]}.flatten(1)]
      out[:other] = []
      if add_footer
        out[:footer] = []
        groups << :footer
      end

      each do |l|
        found = false
        groups.each do |g|
          if l.in_group_for_action?(@options[:action], g)
            out[g] << l
            found = true
            next
          end
        end
        out[:other] << l unless found
      end
      out
    end

    alias_method :to_ary, :resolve

    %w(each map size first last any?).each do |meth|
      define_method meth do |*args, &block|
        resolve.send meth, *args, &block
      end
    end

    private
    def returning_a_copy &block
      out = ActionLinks.new options
      out.instance_eval &block
      out
    end
  end

  class Link
    REQUIRED_ATTRIBUTES = %i(href content)

    attr_reader :context

    def initialize options={}
      @options = options
    end

    def bind_to_context context
      @context = context
      self
    end

    def method *args
      link_method *args
    end

    def class *args
      link_class *args
    end

    def method_missing name, *args, &block
      if block_given?
        @options[name] = block
      elsif args.size == 0
        out = @options[name]
        out = context.instance_exec(&out) if out.is_a?(Proc)
        out
      else
        @options[name] = args.first
      end
    end

    def options
      @options.symbolize_keys
    end

    def complete?
      @missing_attributes = REQUIRED_ATTRIBUTES.select{|a| !@options[a].present?}
      @missing_attributes.empty?
    end

    def enabled_actions
      @options[:_actions].map(&:to_s) || []
    end

    def for_action? action
      enabled_actions.empty? || enabled_actions.include?(action.to_s)
    end

    def actions_for_group group
      val = @options[:_groups][group]
      val.is_a?(Array) ? val.map(&:to_s) : val
    end

    def in_group_for_action? action, group
      vals = actions_for_group(group)
      if vals.is_a?(Array)
        return vals.include?(action.to_s)
      elsif vals.is_a?(String) || vals.is_a?(Symbol)
        vals.to_s == action.to_s
      else
        !!vals
      end
    end

    def enabled?
      enabled = false
      if @options[:_if].nil?
        enabled = true
      elsif @options[:_if].is_a?(Proc)
        enabled = context.instance_exec(&@options[:_if])
      else
        enabled = !!@options[:_if]
      end

      enabled = enabled && check_policy(@options[:_policy]) if @options[:_policy].present?

      enabled
    end

    def check_policy(policy)
      @context.check_policy policy
    end

    def errors
      "Missing attributes: #{@missing_attributes.to_sentence}"
    end

    def html_options
      out = {}
      options.each do |k, v|
        out[k] = v unless k == :content || k == :href || k.to_s =~ /^_/
      end
      out[:class] = out.delete(:link_class)
      out
    end

    def to_html
      if block_given?
        link = Link.new(@options)
        yield link
        return link.bind_to_context(context).to_html
      end
      context.h.link_to content, href, html_options
    end
  end

  class IncompleteLinkDefinition < RuntimeError
  end
end
