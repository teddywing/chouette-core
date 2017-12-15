module Pundit
  module PunditViewPolicy
    extend ActiveSupport::Concern

    included do

      let(:permissions){ nil }
      let(:current_referential){ build_stubbed :referential }
      let(:current_user){ build_stubbed :user, permissions: permissions }
      let(:pundit_user){ UserContext.new(current_user, referential: current_referential) }
      before do
        allow(view).to receive(:pundit_user) { pundit_user }

        allow(view).to receive(:policy) do |instance|
          ::Pundit.policy pundit_user, instance
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Pundit::PunditViewPolicy, type: :view
end
