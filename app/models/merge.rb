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
    puts referential.metadatas.inspect

    metadata_merger = MetadatasMerger.new new, referential
    metadata_merger.merge

    new.metadatas.delete metadata_merger.empty_metadatas

    new.save!
    puts new.metadatas.inspect

    referential.metadatas.each do |metadata|
      metadata.line_ids.each do |line_id|
        metadata.periodes.each do |period|
          puts "Clean data for #{line_id} #{period}"
        end
      end
    end

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
          puts "#{line_id} #{period}"

          line_metadatas.each do |m|
            m.periodes = m.periodes.map do |existing_period|
              if period.begin <= existing_period.begin and
                existing_period.end <= period.end
                # between
                nil
              elsif existing_period.include? period.begin
                # before
                Range.new existing_period.begin, period.begin - 1
              elsif existing_period.include? period.end
                # after
                Range.new period.end + 1, existing_period.end
              end
            end.compact
          end

          attributes = {
            line_ids: [line_id],
            periodes: [period],
            referential_source_id: referential.id,
            created_at: metadata.created_at
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
