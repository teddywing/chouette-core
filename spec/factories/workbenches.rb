FactoryGirl.define do
  factory :workbench do
    name "Gestion de l'offre"

    association :organisation
    association :line_referential
    association :stop_area_referential
  end
end
