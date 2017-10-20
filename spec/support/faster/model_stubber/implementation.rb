require_relative './object_cache'

module ModelStubber

  # Get out of RSpec's example's namespace
  class Implementation

    attr_reader :model, :params

    def initialize model, **params
      @model  = model
      @params = params
    end

    def setup
      ObjectCache.add_to_cache model
      stub_all_relations
      params.each(&method(:setup_att))
      self
    end


    private

    # Workers
    def setup_att key, value
      setup_reflection( model, key, value) && return
    end

    def setup_belongs_to reflection, model, key, value
      mystub(model, key){value}
      has_manys = 
        value.class.reflect_on_all_associations(:has_many).select{|v| v.foreign_type == "#{model.class.name.underscore.pluralize}_type" }
      has_manys.each do | has_many |
        value.send( has_many.name ) << model
      end
      true
    end

    def setup_reflection model, key, value
      case reflection = model.class.reflections[key.to_s]
      when ActiveRecord::Reflection::BelongsToReflection
        setup_belongs_to reflection, model, key, value
      # when ActiveRecord::Reflection::HasManyReflection
      #   setup_has_many reflection, model, key, value
      else
        false
      end
    end


    def stub_all_relations
      reflections.each(&method(:stub_relation))
    end

    def stub_belongs_to name
      singleton.send :attr_reader, name
      define_singleton_method "#{name}=" do |value| 
        instance_variable_set("@#{name}", value) 
        has_manys = 
          value.class.reflect_on_all_associations(:has_many).select{|v| v.foreign_type == "#{self.class.name.underscore.pluralize}_type" }
        has_manys.each do | has_many |
          value.send( has_many.name ) << self
        end
        value
      end
    end

    def stub_has_many name
      empty = []
      mystub(model, name){empty}
    end

    def stub_relation name, reflection
      case reflection
      when ActiveRecord::Reflection::BelongsToReflection
        stub_belongs_to name
      when ActiveRecord::Reflection::HasManyReflection
        stub_has_many name 
      end
      
    end

    # Meta
    def define_singleton_method name, &blk
      singleton.module_eval do
        define_method(name, &blk)
      end
    end
    def mystub rcv, name, &blk
      class << rcv; self end
        .module_eval do
          define_method(name, &blk)
        end
    end

    # Lazy Values
    def reflections
      @__reflections__ ||= model.class.reflections
    end

    def singleton
      @__singleton__ ||= class << model; self end
    end
  end
end
