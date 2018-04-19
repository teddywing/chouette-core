module CustomFieldsSupport
  extend ActiveSupport::Concern

  included do
    validate :custom_fields_values_are_valid
    after_initialize :initialize_custom_fields

    def self.custom_fields workgroup=:all
      fields = CustomField.where(resource_type: self.name.split("::").last)
      fields = fields.where(workgroup_id: workgroup&.id) if workgroup != :all
      fields
    end

    def self.custom_fields_definitions workgroup=:all
      Hash[*custom_fields(workgroup).map{|cf| [cf.code, cf]}.flatten]
    end

    def method_missing method_name, *args
      if method_name =~ /custom_field_*/ && method_name.to_sym != :custom_field_values && !@custom_fields_initialized
        initialize_custom_fields
        send method_name, *args
      else
        super method_name, *args
      end
    end

    def custom_fields workgroup=:all
      CustomField::Collection.new self, workgroup
    end

    def custom_fields_checksum
      custom_fields.values.map(&:checksum)
    end

    def custom_field_values= vals
      out = {}
      custom_fields.each do |code, field|
        out[code] = field.preprocess_value_for_assignment(vals.symbolize_keys[code.to_sym])
      end
      write_attribute :custom_field_values, out
    end

    def initialize_custom_fields
      return unless self.attributes.has_key?("custom_field_values")
      self.custom_field_values ||= {}
      custom_fields(:all).values.each &:initialize_custom_field
      custom_fields(:all).each do |k, v|
        custom_field_values[k] ||= v.default_value
      end
      @custom_fields_initialized = true
    end

    def custom_field_value key
      (custom_field_values&.stringify_keys || {})[key.to_s]
    end

    private
    def custom_fields_values_are_valid
      custom_fields(:all).values.all?{|cf| cf.valid?}
    end
  end
end
