require 'pundit/rspec'

module Support
  module ApplicationPolicy
    def create_user_context(user:, referential:)
      OpenStruct.new(user: user, context: {referential: referential})
    end
  end
end

RSpec.configure do | c |
  c.include Support::ApplicationPolicy, type: :policy
end
