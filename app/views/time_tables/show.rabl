object @time_table

node do |tt|
  {
    time_table_bounding: tt.presenter.time_table_bounding,
    composition_info: tt.presenter.composition_info,
    day_types: %w(monday tuesday wednesday thursday friday saturday sunday).select{ |d| tt.send(d) }.map{ |d| tt.human_attribute_name(d).first(2)}.join('')
  }
end
attributes :id, :comment

child(:periods, object_root: false) do
  attributes :id, :period_start, :period_end, :position
end

child(:dates, object_root: false) do
  attributes :id, :date, :position, :in_out
end

child(:calendar) do
  attributes :id, :name, :short_name
end

child(:tags, object_root: false) do
  attributes :name
end
