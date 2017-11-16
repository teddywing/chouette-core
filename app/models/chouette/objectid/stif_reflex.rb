module Chouette
  module Objectid
    class StifReflex < Chouette::Objectid::Netex

      attr_accessor :country_code, :zip_code
      validates_presence_of :country_code, :zip_code
      validates :creation_id, presence: false

      @@format = /^([A-Za-z_]+):([0-9A-Za-z_-]+):([A-Za-z]+):([0-9A-Za-z_-]+):([A-Za-z]+)$/

      def initialize(**attributes)
        @provider_id = attributes[:provider_id]
        @country_code = attributes[:country_code]
        @zip_code = attributes[:zip_code]
        super
      end

      def to_s
        "#{self.country_code}:#{self.zip_code}:#{self.object_type}:#{self.local_id}:#{self.provider_id}"
      end
    end
  end
end
