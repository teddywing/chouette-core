module Chouette
  module ObjectidFormater
    class StifCodifligne
      def before_validation(model) 
        # unused method in this context
      end

      def after_commit(model)
        # unused method in this context
      end

      def parse_objectid(definition)
        parts = definition.split(":")
        Chouette::Objectid::StifCodifligne.new(provider_id: parts[0], sync_id: parts[1], object_type: parts[2], local_id: parts[3]).to_s rescue nil
      end
    end
  end
end