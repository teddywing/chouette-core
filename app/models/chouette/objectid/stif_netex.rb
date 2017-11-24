module Chouette
  module Objectid
    class StifNetex < Chouette::Objectid::Netex

      def initialize(**attributes)
        @provider_id = (attributes[:provider_id] ||= 'stif')
        super
      end

      def short_id
        local_id.try(:split, "-").try(:last)
      end
    end
  end
end