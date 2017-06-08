module Support
  module PGCatalog
    # TODO: Check what of the follwowing can be done with ActiveRecord. E.g.
    # @connection.foreign_keys(table)...

    def expect_same_sequence_params(sequence_name)
      expected_seq = get_sequences(source_schema, sequence_name)
      actual_seq   = get_sequences(target_schema, sequence_name)
      expect( actual_seq ).to eq(expected_seq)
    end

    def get_columns(schema_name, table_name)
      execute("SELECT * from information_schema.columns WHERE table_name = '#{table_name}' AND table_schema = '#{schema_name}'")
    end
    def get_foreign_keys(schema_oid, table_name)
      schema_oid = get_schema_oid(schema_oid) unless Integer === schema_oid
      return [] unless schema_oid
      execute(foreign_key_query(schema_oid, table_name))
        .to_a
    end

    def get_schema_oid(schema_name)
      execute("SELECT oid FROM pg_namespace WHERE nspname = '#{schema_name}'")
        .values
        .flatten
        .first
    end

    def get_sequences(schema_name, sequence_name)
      sequences = execute(sequence_query(schema_name, sequence_name))
      sequences.values.flatten.map do | sequence |
        execute "SELECT * from #{schema_name}.#{sequence}"
      end.flat_map(&:to_a)
    end

    def get_table_information(schema_name, table_name)
      execute("SELECT * FROM information_schema.tables WHERE table_name = '#{table_name}' AND table_schema = '#{schema_name}'")
        .to_a
        .map(&without_keys("table_catalog"))
    end


    private
    def base_connection
      ActiveRecord::Base.connection
    end

    def execute(sql)
      base_connection.execute(sql)
    end

    def foreign_key_query(schema_oid, table_name)
      <<-EOQ
        SELECT ct.conname AS constraint_name, pg_get_constraintdef(ct.oid) AS constraint_def
          FROM pg_constraint ct JOIN pg_class rn ON rn.oid = ct.conrelid
          WHERE connamespace = #{schema_oid} AND rn.relname = '#{table_name}' AND rn.relkind = 'r' AND ct.contype = 'f'
      EOQ
    end

    def sequence_query(schema_name, sequence_name)
      <<-EOQ
        SELECT sequence_name FROM information_schema.sequences
          WHERE sequence_schema = '#{schema_name}' AND sequence_name = '#{sequence_name}'
      EOQ
    end

    def without_keys(*keys)
      -> hashy do
        hashy.inject({}) do |h, (k,v)|
          keys.include?(k) ? h : h.merge(k => v)
        end
      end
    end
  end
end

RSpec.configure do | conf |
  conf.include Support::PGCatalog, type: :pg_catalog
end
