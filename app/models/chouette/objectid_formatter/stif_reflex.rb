module Chouette
  module ObjectidFormatter
    class Chouette::ObjectidFormatter::StifReflex
      def before_validation(model) 
        # unused method in this context
      end

      def after_create(model)
        # unused method in this context
      end

      def get_objectid(definition)
        parts = definition.try(:split, ":")
        Chouette::Objectid::StifReflex.new(country_code: parts[0], zip_code: parts[1], object_type: parts[2], local_id: parts[3], provider_id: parts[4]) rescue nil
      end
    end
  end
end