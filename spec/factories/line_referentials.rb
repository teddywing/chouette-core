FactoryGirl.define do
  factory :line_referential do
    sequence(:name) { |n| "Line Referential #{n}" }
    association :line_referential_sync, :factory => :line_referential_sync
  end
end
