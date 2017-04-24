require 'rails_helper'

RSpec.describe StoredProcedures do


  before do
    described_class.create_stored_procedure(:clone_schema)
  end

  let( :source_schema_name ){ "parissudest201604" }
  let( :dest_schema_name ){ "#{source_schema_name}_v1"}

  context "Error cases"  do
    it "raises an error if stored procedure does not exist" do
      expect{ described_class.invoke_stored_procedure(:idonotexist) }
      .to raise_error(ArgumentError, %r{no such stored procedure "idonotexist"})
    end
  end

end
