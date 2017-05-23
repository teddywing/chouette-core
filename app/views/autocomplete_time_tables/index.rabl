collection @time_tables, :object_root => false

node do |time_table|
  {
    :id => time_table.id, :comment => time_table.comment, :objectid => time_table.objectid,
    :time_table_bounding => time_table.presenter.time_table_bounding,
    :composition_info => time_table.presenter.composition_info,
    :tags => time_table.tags.join(','),
    :text => "#{time_table.comment} - #{time_table.display_day_types} - #{time_table.objectid.parts.try(:third)}",
    :color => time_table.color,
    :day_types => time_table.display_day_types,
    :short_id => time_table.objectid.parts.try(:third)
  }
end

