module Chouette
  module ObjectidFormatter
    class Chouette::ObjectidFormatter::StifCodifligne
      def before_validation(model) 
        # unused method in this context
      end

      def after_create(model)
        # unused method in this context
      end

      def get_objectid(definition)
        parts = definition.try(:split, ":")
        Chouette::Objectid::StifCodifligne.new(provider_id: parts[0], sync_id: parts[1], object_type: parts[2], local_id: parts[3]) rescue nil
      end
    end
  end
end