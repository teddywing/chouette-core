require "rails_helper"

RSpec.describe Chouette::AreaType do

  describe "::ALL" do
    it "include all supported types" do
      expect(Chouette::AreaType::ALL).to eq %i(zdep zder zdlp zdlr lda)
    end
  end

  describe ".find" do
    it "returns nil if the given code is unknown" do
      expect(Chouette::AreaType.find('dummy')).to be_nil
    end

    it "returns a AreaType associated to the code" do
      expect(Chouette::AreaType.find('zdep').code).to eq :zdep
    end
  end

  describe ".options" do
    it "returns an array with label and code for each type" do
      allow(Chouette::AreaType).to receive(:all).and_return(%i{zdep lda})
      expect(Chouette::AreaType.options).to eq([["ZDEp", :zdep], ["LDA", :lda]])
    end
  end

end
