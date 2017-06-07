FactoryGirl.define do
  factory :workbench do
    sequence(:name) { |n| "Workbench #{n}" }

    association :organisation, :factory => :organisation
    association :line_referential
    association :stop_area_referential

    trait :with_referential do
      # TODO: change all => to :
      # association :referential,
      #   organisation: { organisation }

      # after(:stub) do |workbench, evaluator|
      #   
      # end

      referentials do |workbench|
        [association(
          :referential,
          organisation: workbench.organisation,
          line_referential: workbench.line_referential,
          stop_area_referential: workbench.stop_area_referential
        )]
      end
    end
  end
end
