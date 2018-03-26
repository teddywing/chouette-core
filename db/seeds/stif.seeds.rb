# coding: utf-8

class ActiveRecord::Base
  def self.create_or_update_by!(key_attribute, &block)
    model = find_or_create_by! key_attribute
    print "Seed #{name} #{key_attribute.inspect} "
    yield model

    puts "[#{(model.changed? ? 'updated' : 'no change')}]"
    model.save!

    model
  end
end

stif = Organisation.create_or_update_by!(code: "STIF") do |o|
  o.name = 'STIF'
end

stop_area_referential = StopAreaReferential.create_or_update_by!(name: "Reflex") do |r|
  r.objectid_format = "stif_netex"
  r.add_member stif, owner: true
end

line_referential = LineReferential.create_or_update_by!(name: "CodifLigne") do |r|
  r.objectid_format = "stif_netex"
  r.add_member stif, owner: true
end

workgroup = Workgroup.create_or_update_by!(name: "Gestion de l'offre théorique IDFm") do |w|
  w.line_referential      = line_referential
  w.stop_area_referential = stop_area_referential
  w.export_types          = ["Export::Netex"]
end

Workbench.update_all workgroup_id: workgroup
