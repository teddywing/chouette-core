module Stif
  module ReflexSynchronization
    class << self
      def defaut_referential
        StopAreaReferential.find_by(name: "Reflex")
      end

      # Todo remove dummy objectid
      def find_by_object_id objectid
        Chouette::StopArea.find_by(objectid: "dummy:StopArea:#{objectid.tr(':', '')}")
      end

      def synchronize_stop_area
        client = Reflex::API.new
        ['getOR', 'getOP'].each do |method|
          results = client.process method
          results = results[:Quay].merge(results[:StopPlace])

          processed = []
          results.each do |id, entry|
            Rails.logger.debug "Reflex - Processing - #{entry.id}"
            processed << self.create_or_update_stop_area(entry)
          end
          processed.each do |entry|
            Rails.logger.debug "Reflex - Set parent for - #{entry.id}"
            self.set_parent entry
          end
        end
      end

      def set_parent entry
        return false unless entry.try(:parent_site_ref) || entry.try(:quays)
        stop = self.find_by_object_id entry.id

        if entry.try(:parent_site_ref)
          stop.parent = self.find_by_object_id entry.parent_site_ref
          stop.save! if stop.changed
        end

        if entry.try(:quays)
          entry.quays.each do |quay|
            children = self.find_by_object_id(quay[:ref])
            next unless children
            children.parent = stop
            children.save! if children.changed?
          end
        end
      end

      def create_or_update_stop_area entry
        stop = Chouette::StopArea.find_or_create_by(objectid: "dummy:StopArea:#{entry.id.tr(':', '')}")
        stop.stop_area_referential = self.defaut_referential

        stop.name          = entry.name
        stop.creation_time = entry.created
        stop.area_type     = entry.area_type
        # stop.object_version = entry.version
        stop.zip_code  = entry.postal_code
        stop.city_name = entry.city

        if stop.changed?
          Rails.logger.debug "Reflex - Updating - #{entry.id}"
          stop.save!
          stop
        end
      end
    end
  end
end
