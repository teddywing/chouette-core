class AF83::Decorator < ModelDecorator
  include AF83::EnhancedDecorator
  extend AF83::EnhancedDecorator::ClassMethods

  def self.decorates klass
    instance_decorator.decorates klass
  end

  def self.instance_decorator
    @instance_decorator ||= Class.new(AF83::Decorator::InstanceDecorator)
  end

  def self.with_instance_decorator
    yield instance_decorator
  end

  def self.decorate object, options = {}
    if object.is_a?(ActiveRecord::Base)
      return instance_decorator.decorate object, options
    else
      self.new object, options.update(with: instance_decorator)
    end
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
      out = @options[:links].map{|l| l.bind_to_context(@options[:context], @options[:action])}.select{|l| l.enabled?}
      if @options[:groups].present?
        out = out.select do |l|
          @options[:groups].any? do |g|
            l.in_group_for_action?(g)
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
          if l.in_group_for_action?(g)
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

    def bind_to_context context, action
      @context = context
      @action = action
      self
    end

    def method *args
      link_method *args
    end

    def class *args
      link_class args
    end

    def method_missing name, *args, &block
      if block_given?
        @options[name] = block
      elsif args.size == 0
        out = @options[name]
        out = context.instance_exec(self, &out)  if out.is_a?(Proc)
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

    def for_action? action=nil
      action ||= @action
      enabled_actions.empty? || enabled_actions.include?(action.to_s)
    end

    def actions_for_group group
      val = @options[:_groups][group]
      val.is_a?(Array) ? val.map(&:to_s) : val
    end

    def in_group_for_action? group
      vals = actions_for_group(group)
      if vals.is_a?(Array)
        return vals.include?(@action.to_s)
      elsif vals.is_a?(String) || vals.is_a?(Symbol)
        vals.to_s == @action.to_s
      else
        !!vals
      end
    end

    def primary?
      in_group_for_action? :primary
    end

    def secondary?
      in_group_for_action? :secondary
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

    def extra_class val=nil
      if val.present?
        @options[:link_class] ||= []
        @options[:link_class] << val
        @options[:link_class].flatten!
      else
        (options[:link_class] || []).join(' ')
      end
    end

    def html_options
      out = {}
      options.each do |k, v|
        out[k] = v unless k == :content || k == :href || k.to_s =~ /^_/
      end
      out[:class] = extra_class
      out.delete(:link_class)
      out[:class] += " disabled" if disabled
      out[:disabled] = !!disabled
      out
    end

    def to_html
      if block_given?
        link = Link.new(@options)
        yield link
        return link.bind_to_context(context, @options[:action]).to_html
      end
      context.h.link_to content, href, html_options
    end
  end

  class IncompleteLinkDefinition < RuntimeError
  end

  class InstanceDecorator < Draper::Decorator
    include AF83::EnhancedDecorator
    extend AF83::EnhancedDecorator::ClassMethods
  end
end
