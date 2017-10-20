require_relative 'model_stubber/implementation'

module ModelStubber
  def stub_model klass, **params
    klass.new.tap do | model |
      Implementation.new(model, params).setup
    end
  end
end


RSpec.configure do | conf |
  # Empty Helper's cache before each example or create a helper?
  conf.include ModelStubber, type: :faster
end
