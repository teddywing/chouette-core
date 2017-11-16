FactoryGirl.define do
  factory :workbench do
    name "Gestion de l'offre"
    objectid_format 'stif_netex'

    association :organisation
    association :line_referential
    association :stop_area_referential
    association :output, factory: :referential_suite
  end
end
