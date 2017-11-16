module Chouette
  module ObjectidFormatter
    class StifNetex
      def before_validation(model) 
        model.objectid ||= "__pending_id__#{rand(50)+ rand(50)}"
      end

      def after_commit(model)
        if model.objectid.include? ':__pending_id__'
          model.objectid = Chouette::Objectid::StifNetex.new(provider_id: "stif", object_type: model.class.name.gsub(/Chouette::/,''), local_id: model.local_id).to_s
        end
      end

      def parse_objectid(definition)
        parts = definition.split(":")
        Chouette::Objectid::StifNetex.new(provider_id: parts[0], object_type: parts[1], local_id: parts[2], creation_id: parts[3]).to_s rescue nil
      end
    end
  end
end
