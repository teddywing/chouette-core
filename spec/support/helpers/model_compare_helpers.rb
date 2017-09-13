module Support::ModelCompareHelpers
  
  def values_for_create obj, **overrides
    except = overrides.delete(:except) || []
    keys = obj.attributes.keys - except - %w{id created_at updated_at}
    overrides.inject(obj.attributes.slice(*keys)){ |atts, (k,v)|
      atts.merge k.to_s => v
    }
  end

end

RSpec.configure do | rspec |
  rspec.include Support::ModelCompareHelpers, type: :model
end
