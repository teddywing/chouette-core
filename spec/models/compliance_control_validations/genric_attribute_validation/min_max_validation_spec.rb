RSpec.describe GenericAttributeControl::MinMax do

  let( :factory ){ :generic_attribute_control_min_max }
  subject{ build factory }

  it_behaves_like 'has min_max_values'

  context "numerical validation" do
    it "is valid" do
      subject.minimum = 42
      expect_it.to be_valid
    end

    context "invalid" do
      it "on assignment" do
        subject.minimum = "42s"
        expect_it.not_to be_valid
      end

      it "on creation" do
        instance =  build factory, minimum: "41s" 
        expect(instance).not_to be_valid
      end

    end
  end
end
