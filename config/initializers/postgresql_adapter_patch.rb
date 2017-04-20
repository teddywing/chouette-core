# Transform Wed, 22 Feb 2017...Fri, 24 Feb 201 into Wed, 22 Feb 2017..Thu, 23 Feb 201
module ActiveRecord::ConnectionAdapters::PostgreSQL::OID
  class DateRange < Range
    def cast_value(value)
      result = super value

      if result.respond_to?(:exclude_end?) && result.exclude_end?
        ::Range.new(result.begin, result.end - 1, false)
      else
        result
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
  def initialize_type_map_with_daterange mapping
    initialize_type_map_without_daterange mapping
    # mapping.register_type 3912, ActiveRecord::ConnectionAdapters::PostgreSQL::OID::DateRange.new(mapping.lookup('date'), :daterange)
    mapping.register_type 'daterange', ActiveRecord::ConnectionAdapters::PostgreSQL::OID::DateRange.new(mapping.lookup('date'), :daterange)
  end

  alias_method_chain :initialize_type_map, :daterange
end
