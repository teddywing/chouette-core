FactoryGirl.define do
  factory :line_referential do
    sequence(:name) { |n| "Line Referential #{n}" }
    objectid_format 'stif_codifligne'
  end
end
