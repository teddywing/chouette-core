require_relative 'model_stubber/implementation'

module ModelStubber

  def stub_model builder, **params
    case builder
    when Symbol
      stub_model_with_fg builder, params
    else
      stub_model_with_ar builder, params
    end
  end

  private # symbolic as we are included

  def stub_model_with_ar klass, **params
    klass.new.tap do | model |
      Implementation.new(model, params).setup
    end
  end

  def stub_model_with_fg factory, **params
    build(factory).tap do | model |
      Implementation.new(model, params).setup
    end
  end
end


RSpec.configure do | conf |
  # Empty Helper's cache before each example or create a helper?
  conf.include ModelStubber, type: :faster
  conf.before(:each, type: :faster) do
    ModelStubber::ObjectCache.empty_cache!
  end
end
