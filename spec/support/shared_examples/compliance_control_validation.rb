RSpec.shared_examples_for 'has min_max_values' do

  context "is valid" do
    it { should validate_numericality_of(:minimum) }
    it { should validate_numericality_of(:maximum) }

    it 'if maximum is greater than minimum' do
      min = random_int
      max = min + 100
      subject.assign_attributes maximum: max, minimum: min
      expect_it.to be_valid
    end
  end

  context "is valid" do
    it 'if minimum is well formatted' do
      subject.minimum = "12"
      expect_it.to be_valid
      subject.minimum = "12.0"
      expect_it.to be_valid
      subject.minimum = "12.01"
      expect_it.to be_valid
    end
  end

  context "is invalid" do
    it 'if minimum is not well formatted' do
      subject.minimum = "AA"
      expect_it.not_to be_valid
      subject.minimum = "12."
      expect_it.not_to be_valid
    end

    it 'if no value is provided' do
      subject.minimum = nil
      subject.maximum = nil
      expect_it.not_to be_valid
    end

    it 'if minimum is provided alone' do
      subject.minimum = 42
      subject.maximum = nil
      expect_it.not_to be_valid
    end

    it 'if maximum is provided alone' do
      subject.minimum = nil
      subject.maximum = 42
      expect_it.not_to be_valid
    end

    it 'if maximum is smaller than minimum' do
      min = random_int
      max = min - 1
      subject.assign_attributes maximum: max, minimum: min
      expect_it.not_to be_valid
    end

    it 'and has a correct error message' do
      subject.assign_attributes maximum: 1, minimum: 2
      expect_it.not_to be_valid
      expect( subject.errors.messages[:minimum].first ).to match(I18n.t("compliance_controls.min_max_values", min: 2, max: 1))
    end
  end
end


RSpec.shared_examples_for "has target attribute" do
  context "is valid" do
    it { should validate_presence_of(:target) }
  end
end
