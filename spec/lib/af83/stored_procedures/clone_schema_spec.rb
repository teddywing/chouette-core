require 'spec_helper'

include Support::PGCatalog

RSpec.describe StoredProcedures do
  let( :source_schema ){ "source_schema" }
  let( :target_schema ){ "target_schema" }
  let( :child_table ){ "children" }
  let( :parent_table ){ "parents" }

  before do
    create_schema_with_tables
    StoredProcedures.create_stored_procedure :clone_schema
  end

  context "meta specs describe source schema's introspection" do
    it "shows, sequences are correctly read", :meta do
      expect(get_sequences(source_schema, child_table))
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

      expect(get_sequences(source_schema, parent_table))
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

    it "shows foreign key constraints are correctly read" do
      expect( get_foreign_keys(source_schema, child_table) )
      .to eq([{
        "constraint_name" => "children_parents",
        "constraint_def"  => "FOREIGN KEY (parents_id) REFERENCES source_schema.parents(id)"}])
    end
  end

  context "before cloning" do
    it "target schema does not exist" do
      expect( get_schema_oid(target_schema) ).to be_nil
    end
  end

  context "after cloning" do
    before do
      described_class.invoke_stored_procedure(:clone_schema, source_schema, target_schema, false)
    end

    it "target schema does exist" do
      expect( get_schema_oid(target_schema) ).not_to be_nil
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
     
  end

end

def create_schema_with_tables
  execute("CREATE SCHEMA IF NOT EXISTS #{source_schema}")
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
    EOSQL
end

