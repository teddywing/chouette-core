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
        client = Reflex::API.new
        ['getOR', 'getOP'].each do |method|
          results   = client.process method
          processed = []

          results[:StopPlaceEntrance].each do |id, entry|
            self.create_or_update_access_point entry
          end
          results[:Quay].merge(results[:StopPlace]).each do |id, entry|
            processed << self.create_or_update_stop_area(entry)
          end
          processed.each do |entry|
            self.stop_area_set_parent entry
          end
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

      def create_or_update_access_point entry
        access = Chouette::AccessPoint.find_or_create_by(objectid: "dummy:AccessPoint:#{entry.id.tr(':', '')}")
        access.name           = entry.name
        # access.object_version = entry.version
        access.zip_code       = entry.postal_code
        access.city_name      = entry.city
        access.access_type    = entry.area_type
        access.save if access.changed?
      end

      def create_or_update_stop_area entry
        stop = Chouette::StopArea.find_or_create_by(objectid: "dummy:StopArea:#{entry.id.tr(':', '')}")
        stop.stop_area_referential = self.defaut_referential

        stop.name          = entry.name
        stop.creation_time = entry.created
        stop.area_type     = entry.area_type
        # Todo fixe object_version auto incremented
        # by DefaultAttributesSupport prepare_auto_columns
        # stop.object_version = entry.version
        stop.zip_code  = entry.postal_code
        stop.city_name = entry.city
        stop.save if stop.changed?
        stop
      end
    end
  end
end
