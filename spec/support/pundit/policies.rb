require 'pundit/rspec'

module Support
  module Pundit
    module Policies
      def add_permissions(*permissions, for_user:)
        for_user.permissions ||= []
        for_user.permissions += permissions.flatten
      end

      def create_user_context(user:, referential:)
        UserContext.new(user, referential: referential)
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
          let( :referential )  { build_stubbed :referential }
          let( :user )         { build_stubbed :user }
        end
      end
      def with_user_permission(permission, &blk)
        it "with user permission #{permission.inspect}" do
          add_permissions(permission, for_user: user)
          blk.()
        end
      end
    end
  end
end

RSpec.configure do | c |
  c.include Support::Pundit::Policies, type: :policy
  c.extend Support::Pundit::PoliciesMacros, type: :policy
end
