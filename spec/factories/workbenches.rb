FactoryGirl.define do
  factory :workbench do
    name "Gestion de l'offre"

    association :organisation
    association :line_referential
    association :stop_area_referential
    association :output, factory: :referential_suite
  end

  factory :fast_workbench, class: Workbench do
    name "Fast Workbench"

    association :organisation, strategy: :build
    association :line_referential, strategy: :build
    association :stop_area_referential, strategy: :build
    association :output, factory: :referential_suite, strategy: :build
  end
end
