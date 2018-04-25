class FullTimeZoneInput < SimpleForm::Inputs::CollectionSelectInput
  def collection
    @collection ||= begin
      collection = options.delete(:collection) || ActiveSupport::TimeZone::MAPPING
      collection.respond_to?(:call) ? collection.call : collection.to_a
    end
  end

  def detect_collection_methods
    label, value = options.delete(:label_method), options.delete(:value_method)

    label ||= ->(tz) do
      tz = ActiveSupport::TimeZone[tz.last]
      "(#{tz.formatted_offset}) #{tz.name}"
    end
    value ||= :last

    [label, value]
  end

  def input(wrapper_options = {})
    super wrapper_options
  end
end
