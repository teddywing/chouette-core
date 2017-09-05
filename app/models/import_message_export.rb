# -*- coding: utf-8 -*-
require "csv"
require "zip"

class ImportMessageExport
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :import_messages

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def label(name)
    I18n.t "vehicle_journey_exports.label.#{name}"
  end

  def column_names
    ["criticity", "message key", "message"]
  end


  # t.integer  "criticity"
  # t.string   "message_key"
  # t.hstore   "message_attributes"
  # t.integer  "import_id",           limit: 8
  # t.integer  "resource_id",         limit: 8
  # t.datetime "created_at"
  # t.datetime "updated_at"
  # t.hstore   "resource_attributes"
  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      import_messages.each do |import_message|
        puts import_message.inspect
        puts import_message.message_attributes.deep_symbolize_keys.inspect
        puts I18n.t("import_messages.#{import_message.message_key}", import_message.message_attributes.deep_symbolize_keys)
        csv << [import_message.criticity, import_message.message_key, I18n.t("import_messages.#{import_message.message_key}", import_message.message_attributes.deep_symbolize_keys) ]
      end
    end
  end

  def to_zip(temp_file,options = {})
    ::Zip::OutputStream.open(temp_file) { |zos| }
    ::Zip::File.open(temp_file.path, ::Zip::File::CREATE) do |zipfile|
      zipfile.get_output_stream(label("vj_filename")+route.id.to_s+".csv") { |f| f.puts to_csv(options) }
      zipfile.get_output_stream(label("tt_filename")+".csv") { |f| f.puts time_tables_to_csv(options) }
      zipfile.get_output_stream(label("ftn_filename")+".csv") { |f| f.puts footnotes_to_csv(options) }
    end
  end

end
