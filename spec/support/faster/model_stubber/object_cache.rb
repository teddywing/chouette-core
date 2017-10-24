module ModelStubber
  module ObjectCache extend self

    def add_to_cache model
      if class_cache = cache[model.class]
        model.id = class_cache.keys.last.try(:succ) || 10_001
        class_cache.update( model.id => model )
      else
        cache[model.class] = {}
        stub_class model.class
        add_to_cache model
      end
    end

    def empty_cache!
      @__cache__ = _cache
    end

    private

    def cache
      @__cache__ ||= _cache 
    end
    def _cache
      Hash.new
    end

    def stub_class klass
      kache = cache
      class << klass; self end.module_eval do
        define_method(:find){ |id| kache[klass].fetch(id) } 
      end
    end
  end
end
