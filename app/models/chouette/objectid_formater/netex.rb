module Chouette
  module ObjectidFormater
    class Netex
      def before_validation(model)
        model.objectid ||= Chouette::Objectid::Netex.new(local_id: SecureRandom.uuid, object_type: model.class.name.gsub(/Chouette::/,'')).to_s
      end

      def after_commit(model)
        # unused method in this context
      end

      def parse_objectid(definition)
        parts = definition.split(":")
        Chouette::Objectid::Netex.new(provider_id: parts[0], object_type: parts[1], local_id: parts[2], creation_id: parts[3]).to_s rescue nil
      end
    end
  end
end