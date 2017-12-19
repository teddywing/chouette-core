module IntegrationSpecHelper
  def with_permission permission, &block
    context "with permission #{permission}" do
      let(:permissions){ [permission] }
      context('', &block) if block_given?
    end
  end
end

RSpec.configure do |config|
  config.extend IntegrationSpecHelper, type: :view
end
