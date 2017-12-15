module IntegrationSpecHelper
  extend ActiveSupport::Concern

  included do
    def self.with_permission permission, &block
      context "with permission #{permission}" do
        let(:permissions){ [permission] }
        context('', &block) if block_given?
      end
    end
  end
end


RSpec.configure do |config|
  config.include IntegrationSpecHelper, type: :view
end
