require 'pundit/rspec'

module Support
  module Pundit
    module Policies
      def add_permissions(*permissions, for_user:)
        for_user.permissions ||= []
        for_user.permissions += permissions.flatten
      end

      def create_user_context(user:, referential:)
        OpenStruct.new(user: user, context: {referential: referential})
      end

      def add_permissions(*permissions, for_user:)
        for_user.permissions ||= []
        for_user.permissions += permissions.flatten
      end
    end

    module PoliciesMacros
      def self.extended into
        into.module_eval do
          subject { described_class }
          let( :user_context ) { create_user_context(user: user, referential: referential)  }
          let( :referentail )  { create :referential }
          let( :user )         { create :user }
        end
      end
    end
  end
end

RSpec.configure do | c |
  c.include Support::Pundit::Policies, type: :policy
  c.extend Support::Pundit::PoliciesMacros, type: :policy
end
