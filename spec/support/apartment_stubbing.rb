module Support
  # This is needed for referentials that are stubbed with `build_stubbed`
  # As one cannot switch to such referentials (obviously the schema does not exist)
  # we provide a stub for `scope.where(...` needed in ApplicationPolicy#show 
  module ApartmentStubbing
    def stub_policy_scope(model)
      allow(model.class).to receive(:where).with(id: model.id).and_return double("instance of #{model.class}").as_null_object
    end
  end
end

RSpec.configure do | conf |
  conf.include Support::ApartmentStubbing
end
