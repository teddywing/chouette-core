# -*- coding: utf-8 -*-
require "csv"
require "zip"

class ComplianceCheckMessageExport
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :compliance_check_messages

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
    ["criticity", "message key", "message", "resource objectid"]
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      compliance_check_messages.each do |compliance_check_message|
        csv << [compliance_check_message.compliance_check.criticity, compliance_check_message.message_attributes[:test_id], I18n.t("compliance_check_messages.#{compliance_check_message.message_key}", compliance_check_message.message_attributes.deep_symbolize_keys), compliance_check_message.resource_attributes[:objectid] ]
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
