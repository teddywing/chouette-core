module Support
  module PGCatalog
    # TODO: Check what of the follwowing can be done with ActiveRecord. E.g.
    # @connection.foreign_keys(table)...

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

    def get_sequences(schema_name, table_name)
      sequences = execute <<-EOSQL
        SELECT sequence_name FROM information_schema.sequences
          WHERE sequence_schema = '#{schema_name}' AND sequence_name LIKE '#{table_name}%'
      EOSQL
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
      key = [:foreign_key_query, schema_oid, table_name]
      get_or_create_query(key){ <<-EOQ
      SELECT ct.conname AS constraint_name, pg_get_constraintdef(ct.oid) AS constraint_def
      FROM pg_constraint ct JOIN pg_class rn ON rn.oid = ct.conrelid
      WHERE connamespace = #{schema_oid} AND rn.relname = '#{table_name}' AND rn.relkind = 'r' AND ct.contype = 'f'
        EOQ
      }
    end

    def sequence_properties_query(schema_name, sequence_name)
      key = [:sequence_properies_query, schema_name, sequence_name]
      get_or_create_query(key){ <<-EOQ
                                Coming Soon
        EOQ
      }
      
    end

    def get_or_create_query(query_key, &query_value)
      queries.fetch(query_key){ queries[query_key] = query_value.() }
    end

    def queries
       @__queries__ ||= {}
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
