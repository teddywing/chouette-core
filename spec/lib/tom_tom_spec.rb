RSpec.describe TomTom do
  describe ".enabled?" do
    it "returns true when API key is set" do
      dummy_key = ['a'..'z','A'..'Z',0..9].map(&:to_a).flatten.sample(32).join
      allow(TomTom).to receive(:api_key).and_return dummy_key
      expect(TomTom.enabled?).to be true
    end

    it "returns false without an API key" do
      allow(TomTom).to receive(:api_key).and_return ''
      expect(TomTom.enabled?).to be_falsy
    end

    it "returns false when API key is malformed" do
      allow(TomTom).to receive(:api_key).and_return 'it will not work'
      expect(TomTom.enabled?).to be_falsy
    end
  end
end
