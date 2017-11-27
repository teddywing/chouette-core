FactoryGirl.define do
  factory :stop_area_referential, :class => StopAreaReferential do
    sequence(:name) { |n| "StopArea Referential #{n}" }
    objectid_format 'stif_reflex'
  end
end
