module Stif
  module ReflexSynchronization
    class << self
      def defaut_referential
        StopAreaReferential.find_by(name: "Reflex")
      end

      def find_by_object_id objectid
        Chouette::StopArea.find_by(objectid: objectid)
      end

      def synchronize
        tstart        = Time.now
        client        = Reflex::API.new
        processed     = []
        initial_count = Chouette::StopArea.where(deleted_at: nil).count

        ['getOR', 'getOP'].each do |method|
          start   = Time.now
          results = client.process method
          Rails.logger.info "Reflex:sync - Process #{method} done in #{Time.now - start} seconds"
          results.each do |type, entries|
            Rails.logger.info "Reflex:sync - #{entries.count} #{type} retrieved"
          end

          # Create or update stop_area for every quay, stop_place
          stop_areas = results[:Quay].merge(results[:StopPlace])
          start = Time.now
          stop_areas.each do |id, entry|
            processed << self.create_or_update_stop_area(entry).objectid
          end
          Rails.logger.info "Reflex:sync - Create or update StopArea done in #{Time.now - start} seconds"

          # Walk through every entry and set parent stop_area
          start = Time.now
          stop_areas.each do |id, entry|
            self.stop_area_set_parent entry
          end
          Rails.logger.info "Reflex:sync - StopArea set parent done in #{Time.now - start} seconds"
          {
            imported: Chouette::StopArea.where(deleted_at: nil).count - initial_count,
            deleted: self.set_deleted_stop_area(processed.uniq)
          }
        end
      end

      def set_deleted_stop_area processed
        start   = Time.now
        deleted = Chouette::StopArea.where(deleted_at: nil).pluck(:objectid).uniq - processed
        deleted.each_slice(50) do |object_ids|
          Chouette::StopArea.where(objectid: object_ids).update_all(deleted_at: Time.now)
        end
        Rails.logger.info "Reflex:sync - StopArea #{deleted.size} stop_area deleted since last sync in #{Time.now - start} seconds"
        deleted
      end

      def stop_area_set_parent entry
        return false unless entry.try(:parent_site_ref) || entry.try(:quays)
        stop = self.find_by_object_id entry.id
        return false unless stop

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
        # Hack, on save object_version will be incremented by 1
        entry.version = entry.version.to_i + 1  if access.persisted?
        access.stop_area = stop_area
        {
          :name           => :name,
          :access_type    => :access_type,
          :object_version => :version,
          :zip_code       => :postal_code,
          :city_name      => :city,
          :import_xml     => :xml
        }.each do |k, v| access[k] = entry.try(v) end
        access.save if access.changed?
      end

      def create_or_update_stop_area entry
        stop = Chouette::StopArea.find_or_create_by(objectid: entry.id)
        stop.deleted_at            = nil
        stop.stop_area_referential = self.defaut_referential
        {
          :name           => :name,
          :creation_time  => :created,
          :area_type      => :area_type,
          :object_version => :version,
          :zip_code       => :postal_code,
          :city_name      => :city,
          :import_xml     => :xml
        }.each do |k, v| stop[k] = entry.try(v) end
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
