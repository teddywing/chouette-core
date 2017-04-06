object @time_table

attributes :id, :comment
node do |tt|
  {
    time_table_bounding: tt.presenter.time_table_bounding,
    tags: tt.tags.map(&:name),
    day_types: %w(monday tuesday wednesday thursday friday saturday sunday).select{ |d| tt.send(d) }.map{ |d| tt.human_attribute_name(d).first(2)}.join(''),
    periode_range: month_periode_enum(3)
  }
end

child(:periods, object_root: false) do
  attributes :id, :period_start, :period_end
end

child(:dates, object_root: false) do
  attributes :id, :date, :in_out
end

child(:calendar) do
  attributes :id, :name
end
