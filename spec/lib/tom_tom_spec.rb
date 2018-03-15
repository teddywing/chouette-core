RSpec.describe TomTom do
  describe ".enabled?" do
    it "returns true when API key is set" do
      TomTom.instance_variable_set(:@api_key, 'fake key')

      expect(TomTom.enabled?).to be true
    end

    it "returns false without an API key" do
      TomTom.instance_variable_set(:@api_key, '')

      expect(TomTom.enabled?).to be false
    end
  end
end
