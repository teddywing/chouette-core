attributes :objectid => :object_id
[ :object_version, :created_at, :updated_at, :creator_id].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

