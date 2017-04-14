require 'rails_helper'

RSpec.describe StoredProcedures do

  include Support::PGCatalog
  context "clone_schema creates correct table in dest schema" do
    before do
      drop_schema!(dest_schema_name)
    end

    it "creates the schema" do
      expect( get_fks!(dest_schema_name, "access_links") ).to be_empty
      described_class.invoke_stored_procedure(:clone_schema, source_schema_name, dest_schema_name, true)
      expect( get_fks!(dest_schema_name, "access_links") )
      .to eq( [{"constraint_name"=>"aclk_acpt_fkey",
                "constraint_def"=>"FOREIGN KEY (access_point_id) REFERENCES parissudest201604_v1.access_points(id)"}])
    end
  end
end
