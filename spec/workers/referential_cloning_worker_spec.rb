require 'spec_helper'
require 'ostruct'

RSpec.describe ReferentialCloningWorker do

  context "given a referential cloning" do

    let( :id ){ double }

    let( :worker ){ described_class.new }

    def make_referential(schema_name)
      return OpenStruct.new( slug: schema_name )
    end

    let( :source_schema ){ "source_schema" }
    let( :target_schema ){ "target_schema" }
    let( :referential_cloning ){ OpenStruct.new(source_referential: make_referential(source_schema),
                                                target_referential: make_referential(target_schema)) }
    let( :cloner ){ 'cloner' }


    before do
      expect( ReferentialCloning ).to receive(:find).with(id).and_return(referential_cloning)
      expect( AF83::SchemaCloner ).to receive(:new).with( source_schema, target_schema ).and_return(cloner)
      expect( cloner ).to receive(:clone_schema)

      expect( referential_cloning ).to receive(:run!)
    end

    it "invokes the correct stored procedure, updates the database and the AASM" do
      expect( referential_cloning ).to receive(:successful!)
      worker.perform(id)
    end
  end

  it "should clone an existing Referential" do
    source_referential = create :referential

    source_referential.switch
    source_time_table = create :time_table

    target_referential = create :referential, created_from: source_referential

    cloning = ReferentialCloning.create source_referential: source_referential, target_referential: target_referential
    ReferentialCloningWorker.new.perform(cloning)

    target_referential.switch
    expect(Chouette::TimeTable.where(objectid: source_time_table.objectid).exists?)
  end


end
