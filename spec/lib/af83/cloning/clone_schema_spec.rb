RSpec.describe AF83::SchemaCloner, type: :pg_catalog do
  let( :source_schema ){ "source_schema" }
  let( :target_schema ){ "target_schema" }
  let( :child_table ){ "children" }
  let( :parent_table ){ "parents" }

  subject { described_class.new source_schema, target_schema }

  context "after cloning" do
    before do
      create_schema_with_tables
      subject.clone_schema
    end

    it "table information is correctly duplicated" do
      expect_same_sequence_params("#{child_table}_id_seq")
      expect_same_sequence_params("#{parent_table}_id_seq")
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


    xit "has the correct foreign keys" do
      expect( get_foreign_keys(target_schema, child_table) )
        .to eq([{
        "constraint_name" => "children_parents",
        "constraint_def"  => "FOREIGN KEY (parents_id) REFERENCES target_schema.parents(id)"}])
    end

    xit "the data has been copied" do
    end

    xit "it has the correct unique keys"
      
    end

    xit "inserts are independent" do
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
    #{parent_table}_id bigint,
     some_key bigint NOT NULL,
      is_orphan boolean DEFAULT false
    );

    CREATE UNIQUE INDEX #{source_schema}.#{child_table}_some_key_idx ON #{source_schema}.#{child_table} (some_key);

    ALTER TABLE #{source_schema}.#{child_table}
      ADD CONSTRAINT #{child_table}_#{parent_table}
      FOREIGN KEY( #{parent_table}_id ) REFERENCES #{source_schema}.#{parent_table}(id);
      INSERT INTO #{source_schema}.#{parent_table} VALUES (100);
      INSERT INTO #{source_schema}.#{child_table} VALUES (1, 100);
    EOSQL
  end
end
