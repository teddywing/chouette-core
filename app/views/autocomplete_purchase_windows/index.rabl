collection @purchase_windows, :object_root => false

node do |window|
  {
    :id => window.id,
    :name => window.name,
    :objectid => window.objectid,
    :color => window.color,
    :short_id => window.get_objectid.short_id,
    :text => "<strong><span class='fa fa-circle' style='color:" + (window.color ? window.color : '#4b4b4b') + "'></span> " + window.name + " - " + window.get_objectid.short_id + "</strong>"
  }
end
