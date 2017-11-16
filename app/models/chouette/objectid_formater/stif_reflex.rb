module Chouette
  module ObjectidFormater
    class StifReflex
      def before_validation(model) 
        # unused method in this context
      end

      def after_commit(model)
        # unused method in this context
      end

      def parse_objectid(definition)
        parts = definition.split(":")
        Chouette::Objectid::StifReflex.new(country_code: parts[0], zip_code: parts[1], object_type: parts[2], local_id: parts[3], provider_id: parts[4]).to_s rescue nil
      end
    end
  end
end