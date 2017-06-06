module AF83
  class SchemaCloner

    attr_reader :source_schema, :target_schema, :include_records
    def clone_schema(source_schema, target_schema, include_records: true)
      @source_schema = source_schema
      @target_schema = target_schema
      @include_records = include_records

      clone_schema_
    end

    private
    def assure_schema_preconditons
      raise RuntimeError, "Target Schema #{target_schema} does already exist" unless
      execute("SELECT oid FROM pg_namespace WHERE nspname = '#{target_schema}' LIMIT 1").empty?

      raise RuntimeError, "Source Schema #{source_schema} does not exist" unless source
    end

    def clone_schema_
      assure_schema_preconditons
    end
    def connection
      @__connection__ ||= ActiveRecord::Base.connection
    end
    def execute(str)
      connection.execute(str).to_a
    end

    def source
       @__source__ ||= execute("SELECT oid FROM pg_namespace WHERE nspname = '#{source_schema}' LIMIT 1").first;
    end
    def source_oid
      @__source_oid__ ||= source["oid"].to_i;
    end
  end
end
