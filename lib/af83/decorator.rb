class AF83::Decorator < ModelDecorator
  include AF83::Decorator::EnhancedDecorator
  extend AF83::Decorator::EnhancedDecorator::ClassMethods

  def self.decorates klass
    instance_decorator.decorates klass
  end

  def self.instance_decorator
    @instance_decorator ||= begin
      klass = Class.new(AF83::Decorator::InstanceDecorator)
      klass.delegate_all
      klass
    end
  end

  def self.with_instance_decorator
    @_with_instance_decorator = true
    yield instance_decorator
    @_with_instance_decorator = false
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

    delegate :each, :map, :size, :first, :last, :any?, :select, to: :resolve

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
    alias_method :to_ary, :resolve

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

    private
    def returning_a_copy &block
      out = ActionLinks.new options
      out.instance_eval &block
      out
    end
  end

  class IncompleteLinkDefinition < RuntimeError
  end

  class InstanceDecorator < Draper::Decorator
    include AF83::Decorator::EnhancedDecorator
    extend AF83::Decorator::EnhancedDecorator::ClassMethods
  end
end
