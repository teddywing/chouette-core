require 'spec_helper'

RSpec.describe StoredProcedures do
  context "clone schema with data" do
    before do
      seed_schema "source_schema"
    end

    context "before cloning source schema is set up correctly w/o target_schema" do
      it "with two different organisations" do
        expect(Organisation.count).to eq(2)
      end
    end
  end

  private
  def seed_schema schema_name
    source_org, target_org = 2.times.map{ create :organisation }
    
  end
end
