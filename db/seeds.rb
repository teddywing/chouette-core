# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

stif = Organisation.find_or_create_by(name: "STIF", code: "STIF")

stif.users.find_or_create_by!(username: "admin") do |user|
  user.email = 'stif-boiv@af83.com'
  user.password = "secret"
  user.name = "STIF Administrateur"
  user.skip_confirmation!
end

OfferWorkbench.find_or_create_by(name: "Gestion de l'offre", organisation: stif)

operator = Organisation.find_or_create_by(name: "Transporteur A")

operator.users.find_or_create_by!(username: "transporteur") do |user|
  user.email = 'stif-boiv+transporteur@af83.com'
  user.password = "secret"
  user.name = "Martin Lejeune"
  user.skip_confirmation!
end

stop_area_referential = StopAreaReferential.find_or_create_by(name: "Reflex") do |referential|
  referential.add_member stif, owner: true
  referential.add_member operator
end

10.times do |n|
  stop_area_referential.stop_areas.find_or_create_by name: "Test #{n}", area_type: "Quay"
end

line_referential = LineReferential.find_or_create_by(name: "CodifLigne") do |referential|
  referential.add_member stif, owner: true
  referential.add_member operator
  LineReferentialSync.create(line_referential: referential)
end

10.times do |n|
  line_referential.lines.find_or_create_by name: "Test #{n}" do |l|
    l.objectid = "Chouette:Dummy:Line:00" + n.to_s
  end
end



offer_workbench = OfferWorkbench.find_or_create_by(name: "Gestion de l'offre", organisation: operator)

[["parissudest201604", "Paris Sud-Est Avril 2016"],
 ["parissudest201605", "Paris Sud-Est Mai 2016"]].each do |slug, name|
  operator.referentials.find_or_create_by!(slug: slug) do |referential|
    referential.name = name
    referential.prefix = slug
    referential.offer_workbench = offer_workbench
    referential.line_referential = line_referential
    referential.stop_area_referential = stop_area_referential
  end
end
