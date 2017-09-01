module TableBuilderHelper
  class Column
    attr_reader :key, :name, :attribute, :sortable

    def initialize(key: nil, name: '', attribute:, sortable: true, link_to: nil)
      if key.nil? && name.empty?
        raise ColumnMustHaveKeyOrNameError
      end

      @key = key
      @name = name
      @attribute = attribute
      @sortable = sortable
      @link_to = link_to
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

    def linkable?
      !@link_to.nil?
    end

    def link_to(*objs)
      @link_to.call(*objs)
    end
  end


  class ColumnMustHaveKeyOrNameError < StandardError; end
end
