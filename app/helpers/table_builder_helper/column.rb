module TableBuilderHelper
  class Column
    attr_reader :key, :name, :attribute, :sortable

    def initialize(key: nil, name: '', attribute:, sortable: true)
      if key.nil? && name.empty?
        raise ColumnMustHaveKeyOrNameError
      end

      @key = key
      @name = name
      @attribute = attribute
      @sortable = sortable
    end

    def value(obj)
      if @attribute.is_a?(Proc)
        @attribute.call(obj)
      else
        obj.try(@attribute)
      end
    end

    def header_label(model = nil)
      return @name unless @name.empty?

      # Transform `Chouette::Line` into "line"
      model_key = model.to_s.demodulize.underscore

      I18n.t("activerecord.attributes.#{model_key}.#{@key}")
    end
  end


  class ColumnMustHaveKeyOrNameError < StandardError; end
end
