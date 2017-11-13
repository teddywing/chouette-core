# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

stop_area_referential = StopAreaReferential.find_or_create_by!(name: "Reflex")
line_referential = LineReferential.find_or_create_by!(name: "CodifLigne")

# Organisations
stif = Organisation.find_or_create_by!(code: "STIF") do |org|
  org.name = 'STIF'
end
operator = Organisation.find_or_create_by!(code: 'transporteur-a') do |organisation|
  organisation.name = "Transporteur A"
end

# Member
line_referential.add_member stif, owner: true
line_referential.add_member operator

stop_area_referential.add_member stif, owner: true
stop_area_referential.add_member operator

# Users
stif.users.find_or_create_by!(username: "admin") do |user|
  user.email = 'stif-boiv@af83.com'
  user.password = "secret"
  user.name = "STIF Administrateur"
end

operator.users.find_or_create_by!(username: "transporteur") do |user|
  user.email = 'stif-boiv+transporteur@af83.com'
  user.password = "secret"
  user.name = "Martin Lejeune"
end

# Include all Lines in organisation functional_scope
stif.update sso_attributes: { functional_scope: line_referential.lines.pluck(:objectid) }
operator.update sso_attributes: { functional_scope: line_referential.lines.limit(3).pluck(:objectid) }

# Set type of objectid_format
line_referential.update objectid_format: "netex"
stop_area_referential.update objectid_format: "netex"
