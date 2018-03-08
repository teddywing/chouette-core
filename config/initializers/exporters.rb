SimpleExporter.define :referential_companies do |config|
  config.separator = ";"
  config.encoding = 'ISO-8859-1'
  config.add_column :name
  config.add_column :registration_number
end
