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

  def action_links action=:index, scope=nil
    return send("#{scope}_links", action) if scope.present?

    self.class.action_links(action)\
    .map{|l| l.bind_to_context(self)}\
    .select{|l| l.enabled?}
  end

  def primary_links action=:index
    action_links(action).select{|l| l.primary_for_action?(action)}
  end

  def check_policy policy
    _object = policy.to_s == "create" ? object.class : object
    method = "#{policy}?"
    h.policy(_object).send(method)
  end

  private
  def self.parse_options args
    options = {}
    %i(weight primary secondary on action actions policy if).each do |k|
      options[k] = args.delete(k) if args.has_key?(k)
    end
    link_options = args.dup

    actions = options.delete :actions
    actions ||= options.delete :on
    actions ||= [options.delete(:action)]
    actions = [actions] unless actions.is_a?(Array)
    link_options[:_actions] = actions.compact

    link_options[:_primary] = options.delete :primary
    link_options[:_secondary] = options.delete :secondary

    link_options[:_if] = options.delete(:if)
    link_options[:_policy] = options.delete(:policy)
    [options, link_options]
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

    %i(primary secondary).each do |k|
      define_method "#{k}_for_action?" do |action|
        vals = send("#{k}_actions")
        if vals.is_a?(Array)
          return vals.include?(action.to_s)
        elsif vals.is_a?(String) || vals.is_a?(Symbol)
          vals.to_s == action.to_s
        else
          !!vals
        end
      end

      define_method "#{k}_actions" do
        val = @options[:"_#{k}"]
        val.is_a?(Array) ? val.map(&:to_s) : val
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
