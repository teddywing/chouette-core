RSpec.describe Range do
  context "intersection" do
    it "is nil (sic) for two distinct ranges" do
      require 'pry'
      binding.pry
      expect( (1..2).intersection(3..4) ).to be_nil
    end

    it "is the smaller of two if one is part of the other" do
      expect( (1..2).intersection(0..3) ).to eq 1..2
      expect( (0..2).intersection(1..2) ).to eq 1..2
    end

    it "is the intersection otherwise" do
      expect( (1..3) & (2..4) ).to eq 2..3
      expect( (2..4) & (1..3) ).to eq 2..3
    end
  end
end
