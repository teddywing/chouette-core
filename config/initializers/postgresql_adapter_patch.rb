# module ::ArJdbc
#   module PostgreSQL
#     def quote_column_name(name)
#       if name.is_a?(Array)
#         name.collect { |n| %("#{n.to_s.gsub("\"", "\"\"")}") }.join(',')
#       else
#         %("#{name.to_s.gsub("\"", "\"\"")}")
#       end
#     end
#   end
# end
# ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:primary_key] = "bigserial primary key"

# Add missing double-quote to write array of daterange in SQL query
# See #1782

class ActiveRecord::ConnectionAdapters::PostgreSQLColumn

  def self.array_to_string(value, column, adapter)
    casted_values = value.map do |val|
      if String === val
        if val == "NULL"
          "\"#{val}\""
        else
          quote_and_escape(adapter.type_cast(val, column, true))
        end
      elsif Range === val
        casted_value = adapter.type_cast(val, column, true)
        "\"#{casted_value}\""
      else
        adapter.type_cast(val, column, true)
      end
    end
    "{#{casted_values.join(',')}}"
  end

end
