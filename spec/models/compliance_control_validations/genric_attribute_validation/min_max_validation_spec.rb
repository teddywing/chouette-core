RSpec.describe GenericAttributeControl::MinMax do

  let( :factory ){ :generic_attribute_control_min_max }
  subject{ build factory }
  context "numerical validation" do
    it "is valid" do
      subject.minimum = 42
      expect_it.to be_valid
    end

    it "is invalid" do
      subject.minimum = "42s"
      expect_it.not_to be_valid
    end
  end
end
