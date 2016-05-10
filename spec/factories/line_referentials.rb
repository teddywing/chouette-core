FactoryGirl.define do
  factory :line_referential do
    sequence(:name) { |n| "StopArea Referential #{n}" }
  end
end
