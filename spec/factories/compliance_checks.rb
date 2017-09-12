FactoryGirl.define do
  factory :compliance_check do
    sequence(:name) { |n| "Compliance check #{n}" }
    type "Type"
    criticity :info
    code "code"
    comment "Text"
    association :compliance_check_set
    association :compliance_check_block
  end
end
