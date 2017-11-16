module Chouette
  module Objectid
    class Netex
      include ActiveModel::Model

      attr_accessor :provider_id, :object_type, :local_id, :creation_id
      validates_presence_of :provider_id, :object_type, :local_id, :creation_id

      def initialize(**attributes)
        @provider_id ||= 'chouette'
        @object_type = attributes[:object_type]
        @local_id = attributes[:local_id]
        @creation_id ||= 'LOC'
      end

      @@format = /^([A-Za-z_-]+):([A-Za-z]+):([0-9A-Za-z_-]+):([A-Za-z]+)$/
      cattr_reader :format

      def to_s
        "#{self.provider_id}:#{self.object_type}:#{self.local_id}:#{self.creation_id}"
      end

      def parts
        self.to_s.match(format).try(:captures)
      end

      def valid?
        parts.present?
      end

      def short_id
        local_id
      end
    end
  end
end
