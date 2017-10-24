module ModelStubber
  # I am wrapping ActiveRecord subclasses in order not to mess with
  # ActiveRecord itself
  class Wrapper

    attr_reader :klass

    def initialize klass
      @klass = klass
    end
    
  end
end
