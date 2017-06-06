include Support::PGCatalog

RSpec.describe AF83::SchemaCloner do
  let( :source_schema ){ "source_schema" }
  let( :target_schema ){ "target_schema" }
  let( :child_table ){ "children" }
  let( :parent_table ){ "parents" }

  subject { described_class.new }

  before do
    create_schema_with_tables
  end

  context "before cloning" do
    it "target schema does not exist" do
      expect( get_schema_oid(target_schema) ).to be_nil
    end
  end

  shared_examples_for "after cloning schema" do

    let( :expected_target_parent_count ){ include_recs ? 1 : 0 }
    let( :expected_target_child_count ){ include_recs ? 1 : 0 }

    it "table information is correctly read" do
      expect(get_table_information(source_schema, child_table))
        .to eq([{"table_schema"=>"source_schema",
                 "table_name"=>"children",
                 "table_type"=>"BASE TABLE",
                 "self_referencing_column_name"=>nil,
                 "reference_generation"=>nil,
                 "user_defined_type_catalog"=>nil,
                 "user_defined_type_schema"=>nil,
                 "user_defined_type_name"=>nil,
                 "is_insertable_into"=>"YES",
                 "is_typed"=>"NO",
                 "commit_action"=>nil}])

      expect( get_table_information(target_schema, child_table))
        .to eq([{"table_schema"=>"target_schema",
                 "table_name"=>"children",
                 "table_type"=>"BASE TABLE",
                 "self_referencing_column_name"=>nil,
                 "reference_generation"=>nil,
                 "user_defined_type_catalog"=>nil,
                 "user_defined_type_schema"=>nil,
                 "user_defined_type_name"=>nil,
                 "is_insertable_into"=>"YES",
                 "is_typed"=>"NO",
                 "commit_action"=>nil}])
    end
      
    it "has the correct sequences" do
      expect(get_sequences(target_schema, child_table))
      .to eq([{"sequence_name"=>"#{child_table}_id_seq",
               "last_value"=>"1",
               "start_value"=>"1",
               "increment_by"=>"1",
               "max_value"=>"9223372036854775807",
               "min_value"=>"1",
               "cache_value"=>"1",
               "log_cnt"=>"0",
               "is_cycled"=>"f",
               "is_called"=>"f"}])

      expect(get_sequences(target_schema, parent_table))
      .to eq([{"sequence_name"=>"#{parent_table}_id_seq",
               "last_value"=>"1",
               "start_value"=>"1",
               "increment_by"=>"1",
               "max_value"=>"9223372036854775807",
               "min_value"=>"1",
               "cache_value"=>"1",
               "log_cnt"=>"0",
               "is_cycled"=>"f",
               "is_called"=>"f"}])
    end

    it "has the correct foreign keys" do
      expect( get_foreign_keys(target_schema, child_table) )
      .to eq([{
        "constraint_name" => "children_parents",
        "constraint_def"  => "FOREIGN KEY (parents_id) REFERENCES target_schema.parents(id)"}])
    end

    it "the data has been copied or not" do
      source_pt_count = count_records(source_schema, parent_table)
      source_ch_count = count_records(source_schema, child_table)
      target_pt_count = count_records(target_schema, parent_table)
      target_ch_count = count_records(target_schema, child_table)

      expect( source_pt_count ).to eq( 1 )
      expect( source_ch_count ).to eq( 1 )
      expect( target_pt_count ).to eq( expected_target_parent_count )
      expect( target_ch_count ).to eq( expected_target_child_count )
    end
  end

  context "step by step", :wip do
    # before do
    #   subject.clone_schema(source_schema, target_schema)
    # end
    it "assure target schema nonexistance" do
      expect{ subject.clone_schema(source_schema, source_schema) }.to raise_error(RuntimeError)
    end
    it "assure source schema's existance" do
      expect{ subject.clone_schema(target_schema, target_schema) }.to raise_error(RuntimeError)
    end

  end

  context "after cloning" do
    before do
      subject.clone_schema(source_schema, target_schema, include_recs: include_recs)
    end

    context "without including records" do
      let( :include_recs ){ false }
      it_behaves_like 'after cloning schema'
    end

    context "with including records" do
      let( :include_recs ){ true }
      it_behaves_like 'after cloning schema'
    end
  end

end

def create_schema_with_tables
  execute <<-EOSQL
    DROP SCHEMA IF EXISTS #{source_schema} CASCADE;
    CREATE SCHEMA #{source_schema};

    CREATE TABLE #{source_schema}.#{parent_table} (
      id bigserial PRIMARY KEY
    );
    CREATE TABLE #{source_schema}.#{child_table} (
      id bigserial PRIMARY KEY,
    #{parent_table}_id bigint
    );
    ALTER TABLE #{source_schema}.#{child_table}
      ADD CONSTRAINT #{child_table}_#{parent_table}
      FOREIGN KEY( #{parent_table}_id ) REFERENCES #{source_schema}.#{parent_table}(id);
      INSERT INTO #{source_schema}.#{parent_table} VALUES (100);
      INSERT INTO #{source_schema}.#{child_table} VALUES (1, 100);
  EOSQL
end

