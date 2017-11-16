module Chouette
  module Objectid
    class StifCodifligne < Chouette::Objectid::Netex

      attr_accessor :sync_id
      validates_presence_of :sync_id
      validates :creation_id, presence: false

      @@format = /^([A-Za-z_]+):([A-Za-z]+):([A-Za-z]+):([0-9A-Za-z_-]+)$/

      def initialize(**attributes)
        @provider_id = attributes[:provider_id]
        @object_type = attributes[:object_type]
        @local_id = attributes[:local_id]
        @sync_id = attributes[:sync_id]
        super
      end

      def to_s
        "#{self.provider_id}:#{self.sync_id}:#{self.object_type}:#{self.local_id}"
      end

    end
  end
end
