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

  def action_links action=:index
    self.class.action_links(action)\
    .map{|l| l.bind_to_context(self)}\
    .select{|l| l.enabled?}
  end

  def check_policy policy
    _object = policy.to_s == "create" ? object.class : object
    method = "#{policy}?"
    h.policy(_object).send(method)
  end

  private
  def self.parse_options args
    options = {}
    %i(primary secondary permission weight).each do |k|
      options[k] = args.delete(k) if args.has_key?(k)
    end
    link_options = args.dup
    actions = args.delete :actions
    actions ||= args.delete :on
    actions ||= [args.delete(:action)]
    actions = [actions] unless actions.is_a?(Array)
    link_options[:_actions] = actions.compact
    link_options[:_if] = args.delete(:if)
    link_options[:_policy] = args.delete(:policy)
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
  end

  class IncompleteLinkDefinition < RuntimeError
  end
end
