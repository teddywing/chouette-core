RSpec.describe Stif::PermissionTranslator do

  context "SSO Permission boiv:read:offer →" do

    it "sessions:create only" do
      expect( described_class.translate(%w{boiv:read:offer}) ).to eq(%w{sessions:create})
    end

  end
end
