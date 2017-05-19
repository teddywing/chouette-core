collection @calendars, :object_root => false
attribute :id, :name, :short_name, :shared
node :text do |cal|
  cal.name
end
