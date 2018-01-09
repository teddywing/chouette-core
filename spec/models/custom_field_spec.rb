require 'rails_helper'

RSpec.describe CustomField, type: :model do

  context "validates" do
    it { should validate_uniqueness_of(:name).scoped_to(:resource_type) }
  end

  context "field access" do
    let( :custom_field ){ build_stubbed :custom_field }

    it "option's values can be accessed by a key" do
      expect( custom_field.options['capacity'] ).to eq("0")
    end

  end
end
