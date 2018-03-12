class Export::ReferentialCompanies < Export::Base
  option :referential_id,
    type: :select,
    collection: ->(){workbench.referentials.all},
    required: true,
    display: ->(val){r = Referential.find(val); link_to(r.name, [r])}

  after_create :call_exporter_async

  def referential
    Referential.find referential_id
  end

  def call_exporter_async
    SimpleExportWorker.perform_async(id)
  end

  def exporter
    SimpleExporter.define :referential_companies do |config|
      config.separator = ";"
      config.encoding = 'ISO-8859-1'
      config.add_column :name
      config.add_column :registration_number
    end

    @exporter ||= begin
      if options[:_exporter_id]
        exporter = SimpleExporter.find options[:exporter_id]
      else
        exporter = SimpleExporter.create configuration_name: :referential_companies
        options[:_exporter_id] = exporter.id
      end
      exporter
    end
  end

  def call_exporter
    tmp = Tempfile.new ["referential_companies", ".csv"]
    referential.switch
    exporter.configure do |config|
      config.collection = referential.companies.order(:name)
    end
    exporter.filepath = tmp.path
    exporter.export
    set_status_from_exporter
    convert_exporter_journal_to_messages
    self.file = tmp
    self.save!
  end

  def set_status_from_exporter
    if exporter.status == :error
      self.status = :failed
    else
      if exporter.status == :success
        self.status = :successful
      else
        self.status = :warning
      end
    end
  end

  def convert_exporter_journal_to_messages
    self.messages.destroy_all
    exporter.journal.each do |journal_item|
      journal_item.symbolize_keys!
      vals = {}

      if journal_item[:kind].to_s == "warning"
        vals[:criticity] = :warning
      elsif journal_item[:kind].to_s == "error"
        vals[:criticity] = :error
      else
        vals[:criticity] = :info
        if journal_item[:event].to_s == "success"
          vals[:message_key] = :success
        end
      end
      vals[:resource_attributes] = journal_item[:row]

      if journal_item[:message].present?
        vals[:message_key] = :full_text
        vals[:message_attributes] = {
          text: journal_item[:message]
        }
      end
      vals[:message_attributes] ||= {}
      vals[:message_attributes][:line] =  journal_item[:line]
      self.messages.build vals
    end
  end
end
