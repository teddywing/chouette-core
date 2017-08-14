module Support::ModelCompareHelpers
  
  def values_for_create obj, except: []
    keys = obj.attributes.keys - except - %w{id created_at updated_at}
    obj.attributes.slice(*keys)
  end

end

RSpec.configure do | rspec |
  rspec.include Support::ModelCompareHelpers, type: :model
end
