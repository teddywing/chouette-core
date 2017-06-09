module AF83
  class SchemaCloner

    attr_reader :source_schema, :target_schema

    def clone_schema
      assure_schema_preconditons
      create_target_schema
    end

    private

    def adjust_default table_name, column_name, default_val
      changed_default = default_val.sub(%r{\Anextval\('#{source_schema}}, "nextval('#{target_schema}")
      execute "ALTER TABLE #{target_schema}.#{table_name} ALTER COLUMN #{column_name} SET DEFAULT #{changed_default}"
    end

    def adjust_defaults table_name
      pairs = execute <<-EOSQL
        SELECT column_name, column_default
          FROM information_schema.columns
          WHERE table_schema = '#{target_schema}' AND table_name = '#{table_name}' AND
                column_default LIKE 'nextval(''#{source_schema}%::regclass)'
      EOSQL
      pairs.each do | pair |
        adjust_default table_name, pair['column_name'], pair['column_default']
      end
    end

    def alter_sequence sequence_name
      seq_props = execute_get_ostruct( "SELECT * FROM #{source_schema}.#{sequence_name}" )
      cycle_on_off = seq_props.is_cycled == 't' ? '' : 'NO'
      execute <<-EOSQL
        ALTER SEQUENCE #{target_schema}.#{sequence_name}
          INCREMENT BY #{seq_props.increment_by}
          MINVALUE #{seq_props.min_value}
          MAXVALUE #{seq_props.max_value}
          START WITH #{seq_props.start_value}
          RESTART WITH #{seq_props.last_value}
          CACHE #{seq_props.cache_value}
      #{cycle_on_off} CYCLE;

        -- TODO: What is this good for?
        SELECT setval('#{target_schema}.#{sequence_name}', #{seq_props.last_value}, '#{seq_props.is_called}');
      EOSQL
    end

    def assure_schema_preconditons
      raise RuntimeError, "Target Schema #{target_schema} does already exist" unless
      execute("SELECT oid FROM pg_namespace WHERE nspname = '#{target_schema}' LIMIT 1").empty?

      raise RuntimeError, "Source Schema #{source_schema} does not exist" unless source
    end

    def clone_foreign_key fk_desc
      relname, conname, constraint_def = fk_desc.values_at(*%w[relname conname constraint_def])
      constraint_def = constraint_def.sub(" REFERENCES #{source_schema}.", " REFERENCES #{target_schema}.")
      execute <<-EOSQL
      ALTER TABLE #{target_schema}.#{relname} ADD CONSTRAINT #{conname} #{constraint_def}
      EOSQL
    end
    def clone_foreign_keys
      get_foreign_keys.each(&method(:clone_foreign_key))
    end

    def clone_sequence sequence_name
      create_sequence sequence_name
      alter_sequence sequence_name
    end
    def clone_sequences
      source_sequence_names.each(&method(:clone_sequence))
    end

    def clone_table table_name
      create_table table_name
    end

    def clone_tables
      table_names.each(&method(:clone_table))
    end

    def create_sequence sequence_name
      execute "CREATE SEQUENCE #{target_schema}.#{sequence_name}"
    end
    def create_table table_name
      execute "CREATE TABLE #{target_schema}.#{table_name} (LIKE #{source_schema}.#{table_name} INCLUDING ALL)"
      execute "INSERT INTO #{target_schema}.#{table_name} SELECT * FROM #{source_schema}.#{table_name}"
      adjust_defaults table_name
    end
    def create_target_schema
      execute("CREATE SCHEMA #{target_schema}")
      clone_sequences
      clone_tables
      clone_foreign_keys
    end
    def execute(str)
      connection.execute(str).to_a
    end
    def execute_get_first(str)
      execute(str).first
    end
    def execute_get_ostruct(str)
      OpenStruct.new(execute_get_first(str))
    end
    def execute_get_values(str)
      execute(str).flat_map(&:values)
    end

    def get_foreign_keys
      execute <<-EOS
        SELECT rn.relname, ct.conname, pg_get_constraintdef(ct.oid) AS constraint_def
          FROM pg_constraint ct JOIN pg_class rn ON rn.oid = ct.conrelid
          WHERE connamespace = #{source['oid']} AND rn.relkind = 'r' AND ct.contype = 'f'
      EOS
    end
    def get_columns(table_name)
    end

    def initialize(source_schema, target_schema)
      @source_schema = source_schema
      @target_schema = target_schema
    end

    #
    #  Memvars
    #  -------
    def connection
      @__connection__ ||= ActiveRecord::Base.connection
    end

    def source
      @__source__ ||= execute("SELECT oid FROM pg_namespace WHERE nspname = '#{source_schema}' LIMIT 1").first;
    end
    def source_sequence_names
      @__source_sequence_names__ ||=
        execute_get_values \
        "SELECT sequence_name::text FROM information_schema.sequences WHERE sequence_schema = '#{source_schema}'"
    end
    def source_oid
      @__source_oid__ ||= source["oid"].to_i;
    end
    def table_names
      @__table_names__ ||= execute_get_values \
        "SELECT TABLE_NAME::text FROM information_schema.tables WHERE table_schema = '#{ source_schema }' AND table_type = 'BASE TABLE'"
    end
  end
end
