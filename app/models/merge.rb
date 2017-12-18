class Merge < ActiveRecord::Base
  extend Enumerize

  belongs_to :workbench
  enumerize :status, in: %w[new pending successful failed running]

  has_array_of :referentials, class_name: 'Referential'

  delegate :output, to: :workbench

  attr_reader :new

  def merge!
    update started_at: Time.now, status: :running

    prepare_new

    referentials.each do |referential|
      merge_referential referential
    end

    save_current
  ensure
    update ended_at: Time.now, status: :successful
  end

  def prepare_new
    new =
      if workbench.output.current
        Rails.logger.debug "Clone current output"
        Referential.new_from(workbench.output.current, fixme_functional_scope).tap do |clone|
          clone.inline_clone = true
        end
      else
        Rails.logger.debug "Create a new output"
        # 'empty' one
        attributes = {
          workbench: workbench,
          organisation: workbench.organisation, # TODO could be workbench.organisation by default
          name: I18n.t("merges.referential_name"),
          slug: "output_#{workbench.id}_#{Time.now.to_i}"
        }
        workbench.output.referentials.new attributes
      end

    new.save!

    output.update new: new
    @new = new
  end

  def merge_referential(referential)
    Rails.logger.debug "Merge #{referential.slug}"

    metadata_merger = MetadatasMerger.new new, referential
    metadata_merger.merge

    new.metadatas.delete metadata_merger.empty_metadatas

    new.save!

    referential.metadatas.each do |metadata|
      metadata.line_ids.each do |line_id|
        metadata.periodes.each do |period|
          # TODO
          puts "Clean data for #{line_id} #{period}"
        end
      end
    end

    # let's merge data :)

    # Routes

    referential_routes = referential.switch do
      referential.routes.all.to_a
    end

    referential_routes_checksums = Hash[referential_routes.map { |r| [ r.id, r.checksum ] }]

    referential_stop_points = referential.switch do
      referential.stop_points.all.to_a
    end

    referential_stop_points_by_route = referential_stop_points.group_by(&:route_id)

    new.switch do
      referential_routes.each do |route|
        existing_route = new.routes.find_by line_id: route.line_id, checksum: route.checksum
        unless existing_route
          attributes = route.attributes.merge(
            id: nil,
            objectid: "merge:route:#{route.checksum}", #FIXME
            # line_id is the same
            # all other primary must be changed
            opposite_route_id: nil #FIXME
          )
          new_route = new.routes.build attributes

          route_stop_points = referential_stop_points_by_route[route.id]

          # Stop Points
          route_stop_points.each do |stop_point|
            attributes = stop_point.attributes.merge(
              id: nil,
              route_id: nil,
              objectid: "merge:stop_point:#{route.checksum}-#{stop_point.position}", #FIXME
            )

            new_route.stop_points.build attributes
          end

          new_route.save!

          # FIXME Route checksum changes if stop points are not defined
          if new_route.checksum != route.checksum
            raise "Checksum has changed: #{route.inspect} #{new_route.inspect}"
          end
        end
      end
    end

    # JourneyPatterns

    referential_journey_patterns, referential_journey_patterns_stop_areas_objectids = referential.switch do
      journey_patterns = referential.journey_patterns.includes(:stop_points)

      journey_patterns_stop_areas_objectids = Hash[
        journey_patterns.map do |journey_pattern|
          [ journey_pattern.id, journey_pattern.stop_points.map(&:stop_area).map(&:objectid)]
        end
      ]

      [journey_patterns, journey_patterns_stop_areas_objectids]
    end

    new.switch do
      referential_journey_patterns.each do |journey_pattern|
        # find parent route by checksum
        associated_route_checksum = referential_routes_checksums[journey_pattern.route_id]
        existing_associated_route = new.routes.find_by checksum: associated_route_checksum

        existing_journey_pattern = new.journey_patterns.find_by route_id: existing_associated_route.id, checksum: journey_pattern.checksum

        unless existing_journey_pattern
          attributes = journey_pattern.attributes.merge(
            id: nil,

            objectid: "merge:journey_pattern:#{existing_associated_route.checksum}-#{journey_pattern.checksum}", #FIXME

            # all other primary must be changed
            route_id: existing_associated_route.id,

            departure_stop_point_id: nil, # FIXME
            arrival_stop_point_id: nil
          )

          stop_areas_objectids = referential_journey_patterns_stop_areas_objectids[journey_pattern.id]

          stop_points = existing_associated_route.stop_points.joins(:stop_area).where("stop_areas.objectid": stop_areas_objectids).order(:position)
          attributes.merge!(stop_points: stop_points)

          new_journey_pattern = new.journey_patterns.create! attributes
          if new_journey_pattern.checksum != journey_pattern.checksum
            raise "Checksum has changed: #{journey_pattern.checksum_source} #{new_journey_pattern.checksum_source}"
          end
        end
      end
    end
  end

  def save_current
    output.update current: new, new: nil
    output.current.update referential_suite: output
  end

  def fixme_functional_scope
    if attribute = workbench.organisation.sso_attributes.try(:[], "functional_scope")
      JSON.parse(attribute)
    end
  end

  def child_change

  end

  class MetadatasMerger

    attr_reader :merge_metadatas, :referential
    def initialize(merge_referential, referential)
      @merge_metadatas = merge_referential.metadatas
      @referential = referential
    end

    delegate :metadatas, to: :referential, prefix: :referential

    def merge
      referential_metadatas.each do |metadata|
        merge_one metadata
      end
    end

    def merged_line_metadatas(line_id)
      merge_metadatas.select do |m|
        m.line_ids.include? line_id
      end
    end

    def merge_one(metadata)
      metadata.line_ids.each do |line_id|
        line_metadatas = merged_line_metadatas(line_id)

        metadata.periodes.each do |period|
          line_metadatas.each do |m|
            m.periodes = m.periodes.map do |existing_period|
              existing_period.remove period
            end.flatten
          end

          attributes = {
            line_ids: [line_id],
            periodes: [period],
            referential_source_id: referential.id,
            created_at: metadata.created_at # TODO check required dates
          }

          # line_metadatas should not contain conflicted metadatas
          merge_metadatas << ReferentialMetadata.new(attributes)
        end
      end
    end

    def empty_metadatas
      merge_metadatas.select { |m| m.periodes.empty? }
    end


  end

end
