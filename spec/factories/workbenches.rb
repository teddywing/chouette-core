FactoryGirl.define do
  factory :workbench do
    name "Gestion de l'offre"

    association :organisation
    association :line_referential
    association :stop_area_referential
    association :output, factory: :referential_suite
  end
end
