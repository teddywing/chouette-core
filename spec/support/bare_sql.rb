module Support
  module BareSQL

    def insert(schema, table, values)
      execute "INSERT INTO #{schema}.#{table} (#{_keys(values)}) VALUES (#{_values values})"
    end

    def execute(sql)
      base_connection.execute(sql)
    end

    def expect_same_content(table_name)
      expected_content = get_content(source_schema, table_name)
      actual_content   = get_content(target_schema, table_name)
      expect( actual_content ).to eq(expected_content)
    end

    def expect_same_sequence_params(sequence_name)
      expected_seq = Hash.without(get_sequences(source_schema, sequence_name).first, 'log_cnt')
      actual_seq   = Hash.without(get_sequences(target_schema, sequence_name).first, 'log_cnt')
      expect( actual_seq ).to eq(expected_seq)
    end

    def get_content(schema_name, table_name)
      execute("SELECT * FROM #{schema_name}.#{table_name}").to_a
    end

    private

    def base_connection
      ActiveRecord::Base.connection
    end

    def _keys(values)
      values.keys.map(&:to_s).join(", ")
    end

    def _values(values)
      values
        .values
        .map(&method(:_format))
        .join(', ')
    end

    def _format(val)
      case val
      when String
        "'#{val}'"
      when TrueClass
        "'t'"
      when FalseClass
        "'f'"
      else
        val.to_s
      end
    end
  end
end
