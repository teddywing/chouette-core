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
          organisation: workbench.organisation, # TODO could be workbench.organisation by default
          name: I18n.t("merges.referential_name"),
          slug: "output_#{workbench.id}_#{Time.now.to_i}"
        }
        workbench.referentials.new attributes
      end

    new.save!

    output.update new: new
    @new = new
  end

  def merge_referential(referential)
    Rails.logger.debug "Merge #{referential.slug}"
    puts referential.metadatas.inspect

    metadata_merger = MetadatasMerger.new new.metadatas, referential.metadatas
    metadata_merger.merge

    metadata_merger.conflits.each do |line_id, periods|
      # clean new on given period
    end
    metadata_merger.destroyed_metadatas.each(&:destroy)

    # let's merge data :)
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

    attr_reader :merge, :metadatas
    def initialize(merge, metadatas)
      @merge, @metadatas = merge, metadatas
    end

    def merge
      metadatas.each do |metadata|
        merge_one metadata
      end
    end

    def line_metadatas(line_id)
      merge.select do |m|
        m.line_ids.include? line_id
      end
    end

    def conflits
      @conflits ||= Hash.new { |h,k| h[k] = [] }
    end

    def destroyed_metadatas
      @destroyed_metadatas ||= []
    end

    def merge_one(metadata)
      metadata.line_ids.each do |line_id|
        line_metadatas = line_metadatas(line_id)

        metadata.periodes do |period|
          before = line_metadatas.find do |m|
            m.periodes.any? { |p| p.include? period.begin }
          end

          if before
            before.end = period.begin - 1
          end

          between = line_metadatas.select do |m|
            m.periodes.any? do |p|
              period.begin < p.begin && p.end < period.end
            end
          end

          destroyed_metadatas.concat between

          after = line_metadatas.find do |m|
            m.periodes.any? { |p| p.include? period.end }
          end

          if after
            after.begin = period.end + 1
          end

          if [before, between, after].any?(&:present?)
            conflits[line_id] << period

            attributes = {
              line_ids: line_id,
              periodes: [period],
              referential_source_id: metadata.referential_source_id,
              created_at: metadata.created_at
            }
            # line_metadatas should not contain conflicted metadatas
            metadatas << ReferentialMetadata.new(attributes)
          end
        end
      end
    end

  end

end
