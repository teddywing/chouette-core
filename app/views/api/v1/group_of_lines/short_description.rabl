object @group_of_line
extends "api/v1/trident_objects/short_description"

[:name].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
