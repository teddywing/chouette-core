object false

node(:total) {@vehicle_journeys.total_entries}
if @vehicle_journeys.length != 0
  child( @vehicle_journeys, :object_root => false) do
    extends "vehicle_journeys/show"
  end
else
  node(:vehicle_journeys) {[]}
end

