require 'spec_helper'
require 'ostruct'

RSpec.describe ReferentialCloningWorker do

  context "given a refererntial cloning" do

    let( :id ){ double }

    let( :worker ){ described_class.new }


    let( :source_schema ){ "source_schema" }
    let( :target_schema ){ "#{source_schema}_tmp" }
    let( :referential_cloning ){ OpenStruct.new(source_referential: OpenStruct.new(slug: source_schema)) } 

    before do
      expect( ReferentialCloning ).to receive(:find).with(id).and_return(referential_cloning)
      expect( StoredProcedures )
        .to receive(:invoke_stored_procedure)
          .with(:clone_schema, source_schema, target_schema, true)

      expect( worker ).to receive(:execute_sql).with( "DROP SCHEMA #{source_schema} CASCADE;" )

      expect( referential_cloning ).to receive(:run!)
    end

    it "invokes the correct stored procedure, updates the database and the AASM" do
      expect( worker ).to receive(:execute_sql).with( "ALTER SCHEMA #{target_schema} RENAME TO #{source_schema};" )
      expect( referential_cloning ).to receive(:successful!)
      worker.perform(id)
    end

    it "handles failure correctly" do
      expect( worker )
        .to receive(:execute_sql)
          .with( "ALTER SCHEMA #{target_schema} RENAME TO #{source_schema};" )
          .and_raise(RuntimeError)
      
      expect( referential_cloning ).to receive(:failed!)
      worker.perform(id)
    end
  end
  
end
