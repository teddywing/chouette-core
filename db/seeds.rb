# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

stif = Organisation.find_or_create_by(name: "STIF")

stop_area_referential = StopAreaReferential.find_or_create_by(name: "Reflex") do |referential|
  referential.add_member stif, owner: true
end

10.times do |n|
  stop_area_referential.stop_areas.find_or_create_by name: "Test #{n}", area_type: "Quay"
end

line_referential = LineReferential.find_or_create_by(name: "CodifLigne") do |referential|
  referential.add_member stif, owner: true
end

10.times do |n|
  line_referential.lines.find_or_create_by name: "Test #{n}"
end

OfferWorkbench.find_or_create_by(name: "Gestion de l'offre", organisation: stif)