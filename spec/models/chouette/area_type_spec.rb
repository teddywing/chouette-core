require "rails_helper"

RSpec.describe Chouette::AreaType do

  describe "::ALL" do
    it "includes all supported types" do
      expect(Chouette::AreaType::ALL).to match_array( %i(zdep zder zdlp zdlr lda gdl) )
    end
  end

  describe ".find" do
    it "returns nil if the given code is unknown" do
      expect(Chouette::AreaType.find('dummy')).to be_nil
    end

    it "returns an AreaType associated to the code" do
      expect(Chouette::AreaType.find('zdep').code).to eq :zdep
    end
  end

  describe ".options" do
    before do
      Chouette::AreaType.reset_caches!
    end

    it "returns an array with label and code for each type" do
      allow(Chouette::AreaType).to receive(:all).and_return(%i{zdep lda})

      expected_options = [
        [Chouette::AreaType.find('zdep').label, :zdep],
        [Chouette::AreaType.find('lda').label, :lda]
      ]
      expect(Chouette::AreaType.options).to eq(expected_options)
    end
  end

end
