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

      def synchronize
        start  = Time.now
        client = Reflex::API.new

        ['getOR', 'getOP'].each do |method|
          results = client.process method
          Rails.logger.info "Reflex:sync - Process #{method} done in #{Time.now - start} seconds"
          results.each do |type, entries|
            Rails.logger.info "Reflex:sync - #{entries.count} #{type} retrieved"
          end

          # Create or update stop_area for every quay, stop_place
          stop_areas = results[:Quay].merge(results[:StopPlace])
          start = Time.now
          stop_areas.each do |id, entry|
            self.create_or_update_stop_area entry
          end
          Rails.logger.info "Reflex:sync - Create or update StopArea done in #{Time.now - start} seconds"

          # Walk through every entry and set parent stop_area
          start = Time.now
          stop_areas.each do |id, entry|
            self.stop_area_set_parent entry
          end
          Rails.logger.info "Reflex:sync - StopArea set parent done in #{Time.now - start} seconds"
        end
      end

      def stop_area_set_parent entry
        return false unless entry.try(:parent_site_ref) || entry.try(:quays)
        stop = self.find_by_object_id entry.id

        if entry.try(:parent_site_ref)
          stop.parent = self.find_by_object_id entry.parent_site_ref
          stop.save if stop.changed
        end

        if entry.try(:quays)
          entry.quays.each do |quay|
            children = self.find_by_object_id(quay[:ref])
            next unless children
            children.parent = stop
            children.save if children.changed?
          end
        end
      end

      def create_or_update_access_point entry, stop_area
        access = Chouette::AccessPoint.find_or_create_by(objectid: "dummy:AccessPoint:#{entry.id.tr(':', '')}")
        entry.version = entry.version.to_i + 1  if access.persisted?
        access.name           = entry.name
        access.stop_area      = stop_area
        access.object_version = entry.version
        access.zip_code       = entry.postal_code
        access.city_name      = entry.city
        access.access_type    = entry.area_type
        access.save if access.changed?
      end

      def create_or_update_stop_area entry
        stop = Chouette::StopArea.find_or_create_by(objectid: "dummy:StopArea:#{entry.id.tr(':', '')}")
        # Hack, on save object_version will be incremented by 1
        entry.version = entry.version.to_i + 1  if stop.persisted?

        stop.stop_area_referential = self.defaut_referential
        stop.name           = entry.name
        stop.creation_time  = entry.created
        stop.area_type      = entry.area_type
        stop.object_version = entry.version
        stop.zip_code       = entry.postal_code
        stop.city_name      = entry.city
        stop.save if stop.changed?

        # Create AccessPoint from StopPlaceEntrance
        if entry.try(:entrances)
          entry.entrances.each do |entrance|
            self.create_or_update_access_point entrance, stop
          end
        end
        stop
      end
    end
  end
end
