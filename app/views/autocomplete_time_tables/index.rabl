collection @time_tables, :object_root => false

node do |time_table|
  {
    :id => time_table.id,
    :comment => time_table.comment,
    :objectid => time_table.objectid,
    :time_table_bounding => time_table.presenter.time_table_bounding,
    :composition_info => time_table.presenter.composition_info,
    :tags => time_table.tags.join(','),
    :color => time_table.color,
    :day_types => time_table.display_day_types,
    :short_id => time_table.get_objectid.short_id,
    :text => "<strong><span class='fa fa-circle' style='color:" + (time_table.color ? time_table.color : '#4b4b4b') + "'></span> " + time_table.comment + " - " + time_table.get_objectid.short_id + "</strong><br/><small>" + time_table.display_day_types + "</small>"
  }
end
