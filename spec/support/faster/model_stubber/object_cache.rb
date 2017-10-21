module ModelStubber
  module ObjectCache extend self

    def add_to_cache model
      model.id = cache[model.class].keys.last.try(:succ) || 1
      cache[model.class].update( model.id => model )
    end

    def empty_cache!
      @__cache__ = _cache
    end

    private

    def cache
      @__cache__ ||= _cache 
    end
    def _cache
      Hash.new { |h, k| h[k] = {} }
    end

  end
end
